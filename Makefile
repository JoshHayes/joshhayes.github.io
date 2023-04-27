SITENAME := joshhayes-github-io

.ONESHELL:

.PHONY: build
build:
	stack build
	stack exec ${SITENAME} rebuild

.PHONY: watch
watch:
	stack build
	stack exec ${SITENAME} rebuild
	stack exec ${SITENAME} watch

.PHONY: clean
clean:
	stack exec ${SITENAME} clean
