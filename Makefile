SHELL:=/bin/bash
export PATH:=$(shell npm bin):$(PATH)

run: node_modules
	docpad run --silent

static: clean node_modules
	docpad generate --env static --silent

clean:
	rm -rf out

node_modules: node_modules/npm_install.d

node_modules/npm_install.d: package.json
	npm prune
	npm install
	touch node_modules/npm_install.d

.PHONY: node_modules run clean static