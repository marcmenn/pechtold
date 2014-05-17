#!/bin/bash
npm install
node_modules/.bin/docpad generate --env static
rsync -rvzp --size-only --delete out/ upload@dev.global-communication.de:/home/pechtold.global-communication.de/www/