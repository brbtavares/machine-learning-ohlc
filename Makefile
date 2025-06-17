lint:
	Rscript -e 'lintr::lint_dir()'

style:
	Rscript -e 'styler::style_dir(indent_by = 4)'