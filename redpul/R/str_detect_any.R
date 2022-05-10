#' str_detect_any
#' @export str_detect_any
str_detect_any <- function(str, obj) {
  str <- str_to_lower(str)
  obj <- str_to_lower(obj)
  map_lgl(
    map(
      str, function(x) {
        tryCatch(str_detect(obj, x), error = function(err) {
          FALSE
        })
      }
    ),
    any
  )
}
