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
    defaults =
        layout: "default"
        isPage: true
        menuOrder: 10
        pageClass: 'page'

    if model.attributes.relativeDirPath == 'projects'
        unless model.meta.get 'isTag'
            defaults.layout = "included"
            defaults.menuProject = true
            tags = model.meta.get 'tags'
            unless tags
                defaults.tags = [defaultProjectTag]
            else
                tags = [tags] unless Array.isArray tags
                tags.push defaultProjectTag
                model.meta.set 'tags', tags

    model.setMetaDefaults defaults

injectTag = (model) ->
    model.setMeta
        layout: 'tags'
        isPage: 'true'
        menuOrder: 10
        title: model.meta.get 'tag'
        data: tagData
        isTag: true

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
                    item.title = "Projekte"
                    art = ->
                    art.prototype = item
                    a = new art()
                    a.title = "Alle"
                    a.children = []
                    item.children.unshift a

            return result
        secondMenu: ->
            for item in @menu()
                if item.children && item.state != false
                    return item.children
            return []
        byTag: (tag) ->
            @getFiles(tags: $has: @document.tag).toJSON()

        images: partialText('images.jade')
        projects: partialText('projects.jade')
