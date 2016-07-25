# xmemoise 

Forked from [hadley/memoise](https://github.com/hadley/memoise)

# Installation

```
devtools::install_github("danielecook/xmemoise")
```

# Memoization

If a function is called multiple times with the same input, you can
often speed things up by keeping a cache of known answers that it can
retrieve. This is called memoisation <http://en.wikipedia.org/wiki/Memoization>.
The `xmemoise` package is built upon [hadley/memoise](https://github.com/hadley/memoise), which provides a simple syntax 

    mf <- memoise(f)

to create `mf()`, a memoised wrapper around `f()`. You can clear `mf`'s
cache with 

    forget(mf)

, and you can test whether a function is memoised with

    is.memoised(mf) # TRUE
    is.memoised(f)  # FALSE


`xmemoise` extends upon `memoise` by adding in additional types of caches. Items can be cached using the original cache implemented in `memoise` in addition to other options:

* [x] Google Datastore; Switch to using googleAuthR
* [ ] Dropbox
* [ ] Google Storage
* [ ] AWS


# Memoization with google datastore

Google Datastore 

There are a few trade-offs to using google datastore for memoization.

```
key <- "<google cloud oauth key>"
secret <- "<google cloud oauth secret>"
authenticate_datastore(key, secret, "<project-id>")

mem_fib <- memoise(fib, cache = datastore_cache("custom_cache_name"))
mem_fib(20) # Saved to datastore; Can be retrieved on another computer.
mem_fib(20) # Cached version retrieved from google datastore.
```