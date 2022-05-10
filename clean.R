library(fs)
library(stringr)
library(purrr)
files <- dir_ls(getwd(), all = T, recurse = T)

walk(
  files[str_detect(files, '[.]env$')],
  ~ file_delete(.)
)


walk(
  files[str_detect(files, '')],
  # ~ file_delete(.)
  ~ print(.)
)
