library("devtools")

revdep_check_resume(bioconductor = TRUE)
revdep_check_save_summary()
revdep_check_print_problems()
