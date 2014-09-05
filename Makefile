SHELL:=/bin/bash
export PATH:=$(shell npm bin):$(PATH)
IMG_SRC:="$(HOME)/Dropbox/marcusmennemeier/Bilder Projekte 2014-09-01/"

run: node_modules
	docpad run

clean:
	rm -rf out

import_images:
	rsync --delete --recursive --checksum --itemize-changes --times --exclude=/index $(IMG_SRC) src/files/associated-files

node_modules: node_modules/npm_install.d

node_modules/npm_install.d: package.json
	npm install
	touch node_modules/npm_install.d

.PHONY: node_modules import_images run clean