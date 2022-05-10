#' ndexrSpinner
#' @export ndexrSpinner
ndexrSpinner <- function(x) {
  spinners <- sample(dir_ls("www/images/spinners/"), 1)
  spinners <- str_remove_all(spinners, "www/")
  withSpinner(x, image = spinners)
}
