# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration

defaultProjectTag = "index"

partialText = (file) ->
    {extname} = require 'path'
    {readFileSync} = require 'fs'
    data = readFileSync "./src/partials/#{file}"
    return "<t render=\"#{extname file}\">\n#{data}\n</t>"

modelDefaults = (model) ->
    defaults =
        layout: "default"
        isPage: true
        menuOrder: 0
        pageClass: 'page'

    if model.attributes.relativeDirPath == 'projects'
        unless model.attributes.basename == 'index'
            defaults.menuHidden = true
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
        menuOrder: 0

module.exports =
    collections:
        pages: ->
            @getCollection('html').findAllLive({},[{menuOrder:1},{menuTitle:1}]).on 'add', modelDefaults

    plugins:
        tags:
            extension: '.html'
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
                    console.log item.children
            return result
        secondMenu: ->
            for item in @menu()
                if item.children && item.state != false
                    return item.children
            return []
        images: partialText('images.jade')
        projects: partialText('projects.jade')
