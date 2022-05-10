#' setDefault
#' @export setDefault
setDefault <- function(value, default) {
  if (length(value) > 1) {
    return(value)
  }
  ifelse(is.null(value) | !length(nchar(value)), default, value)
}
