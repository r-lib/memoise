# memoise 

Forked from [hadley/memoise](https://github.com/hadley/memoise)

# Installation

```
devtools::install_github("danielecook/memoise")
```

# Memoization

If a function is called multiple times with the same input, you can
often speed things up by keeping a cache of known answers that it can
retrieve. This is called memoisation <http://en.wikipedia.org/wiki/Memoization>.
This is a fork of the  `memoise` package built by Hadley Wickham: [hadley/memoise](https://github.com/hadley/memoise), which provides a simple syntax 

    mf <- memoise(f)

to create `mf()`, a memoised wrapper around `f()`. You can clear `mf`'s
cache with 

    forget(mf)

, and you can test whether a function is memoised with

    is.memoised(mf) # TRUE
    is.memoised(f)  # FALSE


`memoise` extends upon `memoise` by adding in additional types of caches. Items can be cached using the original cache implemented in `memoise` in addition to other options:

* [x] Google Datastore
* [x] cache_filesystem allows caching using dropbox/google drive.
* [X] AWS

# Caches

## Google Datastore

Use `cache_datastore` to set up a cache on google datastore. Requires you to set a `project` and `cache_name`. The `cache_name` 
is used to set the kind for each entity stored on google datastore.

```r
library(xmemoise)

# Generate a memoised function.
mrunif <- memoise(runif, cache = cache_datastore("<project id here>", "rcache"))

mrunif(10) # First run, saves cache
mrunif(10) # Loads cache, results should be identical
```

## AWS S3

Use `cache_s3` to cache objects using s3 storage. Requires you to specify a bucket using `cache_name`. When creating buckets, they must be unique among all s3 users when created.

```r
Sys.setenv("AWS_ACCESS_KEY_ID" = "<access key>",
           "AWS_SECRET_ACCESS_KEY" = "<access secret>")

mrunif <- memoise(runif, cache = cache_s3("<unique bucket name>"))

mrunif(10) # First run, saves cache
mrunif(10) # Loads cache, results should be identical

```

## Filesystem

`cache_filesystem` can be used to cache between computers using Google Drive or Dropbox.

```
dbc <- cache_filesystem("~/Dropbox/.rcache")
mrunif <- memoise(runif, cache = dbc)
mrunif(20) # Results stored in Dropbox .rcache folder will be synced between computers.
```

```
gdc <- cache_filesystem("~/Google Drive/.rcache")
mrunif <- memoise(runif, cache = dbc)
mrunif(20) # Results stored in Google Drive .rcache folder will be synced between computers.
```


