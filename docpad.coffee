# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
    collections:
        pages: ->
            @getCollection("html").findAllLive().on "add", (model) ->
                model.setMetaDefaults({layout:"default", isPage: true})

    templateData:
        site:
            title: "Architekturbüro Pechtold"
        getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title
}

# Export the DocPad Configuration
module.exports = docpadConfig