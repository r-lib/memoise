library("devtools")

options(repos = c(getOption("repos"), INLA = "http://www.math.ntnu.no/inla/R/stable"))

res <- revdep_check(bioconductor = TRUE)
revdep_check_save_summary(res)
revdep_check_save_logs(res)
