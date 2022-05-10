library(aws.s3)
Sys.setenv(
  "AWS_ACCESS_KEY_ID" = "AKIAWEUHS5MEZPH7SYWM",
  "AWS_SECRET_ACCESS_KEY" = "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",
  "AWS_DEFAULT_REGION" = "us-east-2"
)

pg_files <- list.files("volumes/postgres/backups", full.names = TRUE)
message("Uploading files to S3")
lapply(
  pg_files, function(filename) {
    obj_name <- paste0(as.numeric(Sys.time()), ".tar.gz")
    tar(obj_name, filename, compression = "gzip", tar = "tar")
    aws.s3::put_object(filename, obj_name, "redpul")
    file.remove(obj_name)
  }
)
