
import * as http from 'http';
import * as http2 from 'http2';
import * as os from 'os';
import * as fs from 'fs';

const {
  HTTP2_HEADER_CONTENT_LENGTH,
  HTTP2_HEADER_CONTENT_TYPE
} = http2.constants;


// Resolve server port from env.
export const port = process.env.PORT || 8443;
export const httpPort = 8080;
export const appVersion = process.env.APP_VERSION || 'unknown';
export const serverRevision = process.env.SERVER_REVISION || 'unknown';
export const workloadRegion = process.env.K9_WORKLOAD_REGION || 'unknown';
export const workloadNode = process.env.K9_WORKLOAD_NODE || 'unknown';
export const workloadName = process.env.K9_WORKLOAD_NAME || 'unknown';

const tlsKey = process.env.TLS_KEY || 'app/config/tls/selfsigned.key';
const tlsCert = process.env.TLS_CERT || 'app/config/tls/selfsigned.crt';

const options = {
  ALPNProtocols: ['h2'],
  key: loadFileOrComplain(tlsKey),
  cert: loadFileOrComplain(tlsCert)
};

function loadFileOrComplain(file: string): Buffer {
  try {
    return fs.readFileSync(file);
  } catch (err) {
    console.error(`Failed to load file '${file}'. Exiting.`);
    throw err;
  }
}

process.on('SIGINT', function() {
  console.log('shutting down...');
  process.exit(1);
});


const handleRequest = function(request: http2.Http2ServerRequest, response: http2.Http2ServerResponse) {
  console.log(`Received request for URL: ${request.url}`);
  let body;
  let contentType;
  const jsonMode = (request.headers.accept || '').indexOf('application/json') !== -1;
  
  if (jsonMode) {
    contentType = 'application/json';
    body = JSON.stringify({
      'host': os.hostname(),
      'appVersion': appVersion,
      'serverRevision': serverRevision,
      'workload': {
        'region': workloadRegion,
        'node': workloadNode,
        'name': workloadName
      }
    });
  } else {
    contentType = 'text/plain';
    body = [
      `Hello, Cookies Cloud!`,
      ``,
      `Hostname: ${os.hostname()}`,
      `NodeJS Version: ${process.version}`,
      `App Version: ${appVersion}`,
      `Server Revision: ${serverRevision}`,
      `DC Region: ${workloadRegion}`,
      `Compute Node: ${workloadNode}`,
      `Workload: ${workloadName}`
    ].join('\n');
  }

  response.writeHead(200, {
     [HTTP2_HEADER_CONTENT_LENGTH]: Buffer.byteLength(body),
     [HTTP2_HEADER_CONTENT_TYPE]: contentType
  });
  response.end(body);
};

const handleHealthcheck = function(request: http.IncomingMessage, response: http.ServerResponse) {
  response.writeHead(200);
  response.end('OK');
};

export const health = http.createServer(handleHealthcheck);
export const www = http2.createSecureServer(options, handleRequest);

www.on('error', (err) => console.error(err));

export function startServer() {
  console.log('starting echo server...');

  health.listen(httpPort, () => {
    console.log(`health check listening on HTTP port ${httpPort}`);
  });

  www.listen(port, () => {
    console.log(`server listening on TLS port ${port}:`);
    console.log(`- key: ${tlsKey}`);
    console.log(`- cert: ${tlsCert}`);
    console.log("🤖🔊 echo server ready.");
  });
}
