lint:
	Rscript -e 'lintr::lint_dir(linters = lintr::with_defaults(line_length_linter(100), object_name_linter(styles = "snake_case"), indentation_linter(indent = 4)))'

style:
	Rscript -e 'styler::style_dir(indent_by = 4)'
