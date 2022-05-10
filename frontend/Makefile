install: style
	R -e "devtools::install_deps('../state')"
	R -e "devtools::install('../state/')"
	R -e "devtools::document()"
	R -e "devtools::install()"
	R -e "renv::snapshot()"

style:


watch:
	sass www/styles.scss www/styles.css
