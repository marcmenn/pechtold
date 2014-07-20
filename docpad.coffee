# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration

partialText = (file) ->
    {extname} = require 'path'
    {readFileSync} = require 'fs'
    data = readFileSync "./src/partials/#{file}"
    return "<t render=\"#{extname file}\">\n#{data}\n</t>"

module.exports =
    collections:
        pages: ->
            @getCollection("html").findAllLive({},[{menuOrder:1},{menuTitle:1}]).on "add", (model) ->
                model.setMetaDefaults({layout:"default", isPage: true, menuOrder: 0, pageClass: 'page'})

        mainnav: ->
            @getCollection("pages").findAllLive({relativeOutDirPath: '.'})

    plugins:
        tags:
            relativeDirPath: 'projects'
            injectDocumentHelper: (document) ->
                document.setMeta
                    layout: 'tags'

    templateData:
        site:
            title: "Architekturbüro Pechtold"
        getPreparedTitle: ->
            if @document.title then "#{@document.title} | #{@site.title}" else @site.title
        menu: ->
            @generateMenu(document.url, 'pages')
        secondMenu: ->
            for item in menu()
                if item.children && item.state != false
                    return item.children
            return []
        images: partialText('images.jade')
        projects: partialText('projects.jade')
