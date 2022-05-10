#' theme_ndexr
#' @export theme_ndexr
theme_ndexr <- function() {
  theme <- ndexr_colors()

  rebase <- unlist(theme$colors$rebase)
  base_size <- theme$fonts$size$h5
  axis_size <- theme$fonts$size$h5
  background_color <- theme$ndexr$background

  theme_bw(
    base_size = base_size
    # base_family = theme$fonts$primary
  ) +
    theme(
      text = element_text(colour = theme$ndexr$text),
      title = element_text(color = theme$ndexr$title),
      line = element_line(color = theme$ndexr$line),
      rect = element_rect(fill = background_color, color = background_color),
      axis.ticks = element_line(color = theme$ndexr$line),
      axis.line = element_line(
        color = theme$ndexr$line,
        linetype = 1
      ),
      axis.text = element_text(size = axis_size),
      legend.background = element_rect(
        fill = NULL,
        color = NA
      ),
      legend.key = element_rect(
        fill = NULL,
        colour = NULL, linetype = 0
      ),
      panel.background = element_rect(
        fill = background_color,
        colour = background_color
      ),
      panel.border = element_blank(),
      panel.grid = element_line(color = background_color),
      panel.grid.major = element_line(color = background_color),
      panel.grid.minor = element_line(color = background_color),
      plot.background = element_rect(
        fill = NULL, colour = NA,
        linetype = 0
      ),
      axis.title.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.title.y = element_blank(),
      axis.ticks.y = element_blank()
    )
  # theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
}
# }
