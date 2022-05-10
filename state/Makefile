install:
	R -e "devtools::document()"
	R -e "devtools::install()"
style:
	R -e "styler::style_dir(path = '.', exclude_dirs = c('packrat', 'renv'))"

