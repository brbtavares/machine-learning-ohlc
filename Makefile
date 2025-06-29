# Linting targets
lint:
	Rscript scripts/run_lint.R

lint-check:
	Rscript -e 'lintr::lint_package()'

style:
	Rscript -e 'styler::style_pkg(indent_by = 4)'

# Executa linting completo (style + check)
lint-all: style lint-check
