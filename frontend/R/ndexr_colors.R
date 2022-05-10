#' ndexr_colors
#' @export
ndexr_colors <- function() {
  colors <- list(
    minimal = list(
      black = "black",
      white = "white"
    ),
    rebase = list(
      rebase03 = "#fdf6e3",
      rebase02 = "#eee8d5",
      rebase01 = "#93a1a1",
      rebase00 = "#839496",
      rebase0 = "#657b83",
      rebase1 = "#586e75",
      rebase2 = "#073642",
      rebase3 = "#002b36"
    ),
    main = list(
      background = "#131516",
      well = "#242638",
      code = "#1D1F21",
      link = "#2B79A2"
    )
  )

  fonts <- list(
    # primary = "Fira Code",
    # primary ='PT Sans',
    size = list(
      h0 = 40, h1 = 32, h2 = 26, h3 = 22, h4 = 20, h5 = 14, p1 = 13, p2 = 11, em = 11
    )
  )

  base <- list(
    colors = colors,
    fonts = fonts,
    ndexr = list(
      # font = fonts$primary,
      primary = colors$rebase$rebase03,
      background = colors$main$background,
      text = colors$rebase$rebase01,
      title = colors$rebase$rebase0,
      line = colors$rebase$rebase01,
      well = colors$main$well,
      code = colors$main$code,
      link = colors$main$link
    ),
    ndexr_dark = list(
      # font = fonts$primary,
      primary = colors$rebase$rebase03,
      background = colors$main$background,
      text = colors$rebase$rebase01,
      title = colors$rebase$rebase0,
      line = colors$rebase$rebase01,
      well = colors$main$well,
      code = colors$main$code,
      link = colors$main$link
    )
  )

  base
}
