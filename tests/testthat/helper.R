skip_without_gcs_credentials <- function() {
  # -# Sys.setenv("GCS_AUTH_FILE" = "<access key>", "GCS_DEFAULT_BUCKET" = "bucket name")
  if (nzchar(Sys.getenv("GCS_AUTH_FILE")) && nzchar(Sys.getenv("GCS_DEFAULT_BUCKET"))) {
    return(invisible(TRUE))
  }

  testthat::skip("No GCS Credentials")
}

skip_without_aws_credentials <- function() {
  # -# Sys.setenv("AWS_ACCESS_KEY_ID" = "<access key>", "AWS_SECRET_ACCESS_KEY" = "<access secret>")
  if (nzchar(Sys.getenv("AWS_ACCESS_KEY_ID")) && nzchar(Sys.getenv("AWS_SECRET_ACCESS_KEY"))) {
    return(invisible(TRUE))
  }

  testthat::skip("No AWS Credentials")
}

skip_on_travis_pr <- function() {
  if (identical(Sys.getenv("TRAVIS"), "true") && !identical(Sys.getenv("TRAVIS_PULL_REQUEST", "false"), "false")) {
    return(testthat::skip("On Travis PR"))
  }

  invisible(TRUE)
}
