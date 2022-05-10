#' redpul_version
#' @export redpul_version
redpul_version <- function() {
  pkgs <- installed.packages()
  data <-
    map(
      c("state", "redpul", "frontend"),
      ~ pkgs[pkgs[, 1] == ., ][1, ]
    )

  data %>%
    select(Package, Version)
}

#' package_html
#' @export package_html
package_html <- function() {
  packages <- redpul_version()
  map(
    split(packages, 1:nrow(packages)), function(pkg) {
      tagList(
        div(
          em(paste(pkg$Package, "-", pkg$Version)),
          tags$br()
        )
      )
    }
  )
}
