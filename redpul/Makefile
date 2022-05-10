install:
	R -e "devtools::install_deps('../state')"
	R -e "devtools::install_deps('')"
	R -e "devtools::install('../state/')"
	R -e "devtools::document()"
	R -e "devtools::install()"
	R -e "renv::snapshot()"


style:
	R -e "styler::style_dir(path = '.', exclude_dirs = c('packrat', 'renv'))"
	cargo fmt --manifest-path src/rust/Cargo.toml

