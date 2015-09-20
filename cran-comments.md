## Test environments
* Ubuntu 15.04, R 3.2.2 (locally and on Travis)
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs, and one NOTE: The spell checker warned about "memoisation" and a "pre-" prefix.

## Downstream dependencies
I have also run R CMD check on 9 downstream dependencies of memoise
(https://github.com/hadley/memoise/blob/7597e250e87322a064cd97adeea36e5bad669f7d/revdep/summary.md). All packages that I could install passed except:

* lubridate: example failed most likely due to localized system (LC_TIME=de_CH.UTF-8)
