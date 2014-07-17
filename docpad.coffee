# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
setDefaults = (model) ->
    isProject = model.attributes.relativeOutDirPath is 'projects'
    model.setMetaDefaults({layout:"default", isPage: !isProject, menuOrder: 0})

docpadConfig = {
    collections:
        pages: ->
            @getCollection("html").findAllLive({},[{menuOrder:1},{menuTitle:1}]).on "add", (model) ->
                model.setMetaDefaults({layout:"default", isPage: true, menuOrder: 0})

        mainnav: ->
            @getCollection("pages").findAllLive({relativeOutDirPath: '.'})

    templateData:
        site:
            title: "Architekturbüro Pechtold"
        getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title
        images: """<t render="jade">
each file in getDocument().getAssociatedFiles().toJSON()
  img(src=file.url)
</t>
"""
        projects: """<t render="jade">
ul
    each page in getCollection("pages").findAll({relativeOutDirPath: 'projects'}).toJSON()
        li(class=[page.id == document.id ? 'active' : 'inactive'])
            a(href=page.url)= page.title ? page.title : page.name
            span= page.category
</t>
"""
}

# Export the DocPad Configuration
module.exports = docpadConfig