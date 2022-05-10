
#' redpul_find
#' @importFrom purrr discard map
#' @importFrom dplyr bind_rows as_tibble
#' @importFrom jsonlite fromJSON
#' @export
redpul_find <- function(dataset, author = FALSE) {
  if (author) {
    data <- .Call(wrap__redpul_find_author, dataset)
  } else {
    data <- .Call(wrap__redpul_find, dataset)
  }

  message("Finishing up on R side")
  out <- map(data, ~ fromJSON(.)) |>
    map(~ discard(., ~ is.null(.))) |>
    map(as_tibble) |>
    bind_rows()
  out
}
