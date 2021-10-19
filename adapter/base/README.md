
## `//adapter/base`

This package defines base logic inherited by all adapter implementations. The main adapter engine uses this to uniformly
understand and dispatch vendor adapters.

Consequently, JDK implementations should inherit from these classes -- specifically, `RetailAdapterImpl` -- when
implementing retail adapter features.
