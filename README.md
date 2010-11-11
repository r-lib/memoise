# memoise

If a function is called multiple times with the same input, you can
often speed things up by keeping a cache of known answers that it can
retrieve. This is called memoisation <http://en/wikipedia.org/wiki/Memoization>.
The `memoise` package provides a simple syntax 

    mf <- memoise(f)

to create `mf()`, a memoised wrapper around `f()`. You can clear `mf`'s
cache with 

    forget(mf)

, and you can test whether a function is memoised with

    is.memoised(mf) # TRUE
    is.memoised(f)  # FALSE

.
