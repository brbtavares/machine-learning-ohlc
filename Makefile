lint:
	Rscript -e 'lintr::lint_package()'

style:
	Rscript -e 'styler::style_pkg(indent_by = 4)'