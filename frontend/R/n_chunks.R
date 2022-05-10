#' n_chunks
#' @export n_chunks
n_chunks <- function(d, x) split(d, ceiling(seq_along(d) / x))
