# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration

defaultProjectTag = "index"

partial = (file) ->
    {readFileSync} = require 'fs'
    readFileSync "./src/partials/#{file}"

partialText = (file) ->
    {extname} = require 'path'
    return "<t render=\"#{extname file}\">\n#{partial file}\n</t>"

tagData = partial 'tag.jade'

modelDefaults = (model) ->
    tags = model.meta.get 'tags'
    if tags? && !Array.isArray tags
        tags = [tags]
        model.meta.set 'tags', tags

    defaults =
        layout: "default"
        isPage: true
        menuOrder: 10
        pageClass: 'page'

    if model.attributes.relativeDirPath == 'projects'
        unless model.meta.get 'menuTag'
            defaults.layout = "included"
            defaults.menuProject = true
            tags ?= []
            tags.push defaultProjectTag

    model.meta.set 'tags', tags

    model.setMetaDefaults defaults

injectTag = (model) ->
    title = model.meta.get 'tag'
    title = "Projekte" if title is defaultProjectTag

    model.setMeta
        layout: 'tags'
        isPage: 'true'
        menuOrder: 10
        title: title
        data: tagData
        menuTag: true

module.exports =
    renderPasses: 2
    collections:
        pages: ->
            @getCollection('html').findAllLive({},[{menuOrder:1},{menuTitle:1}]).on 'add', modelDefaults

    plugins:
        tags:
            extension: '.html.jade'
            relativeDirPath: 'projects'
            injectDocumentHelper: injectTag

    templateData:
        site:
            title: "Architekturbüro Pechtold"
        getPreparedTitle: ->
            if @document.title then "#{@document.title} | #{@site.title}" else @site.title
        menu: ->
            result = @generateMenu(@document.url, 'documents')
            for item in result
                if item.url == '/projects/'
                    art = ->
                    art.prototype = item
                    a = new art()
                    a.title = "Alle"
                    a.children = []
                    item.children.unshift a

            return result

        filter: (menuItems = []) ->
            result = []
            for item in menuItems
                result.push item unless item.meta.project
            return result

        secondMenu: ->
            for item in @menu()
                if item.children && item.state != false
                    return item.children
            return []
        byTag: (tag) ->
            filter = tags: $has: tag
            if tag == 'index'
                filter = menuProject: true
            @getFiles(filter).toJSON()


        images: partialText('images.jade')
        projects: partialText('projects.jade')
