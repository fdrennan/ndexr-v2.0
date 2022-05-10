#' install_local
#' @export install_local
install_local <- function() {
  purrr::walk(
    c("../state", "../redpul", "../frontend"),
    function(x) {
      devtools::install_deps(x)
      devtools::document(x)
      devtools::install(x)
    }
  )
}
