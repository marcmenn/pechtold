Duo = require 'duo'
{dirname, basename} = require 'path'
coffeescript = require 'coffee-script'

# Export Plugin
module.exports = (BasePlugin) ->
    # Define Plugin
    class DuoPlugin extends BasePlugin
        # Plugin name
        name: 'duo'

        render: (opts, next) ->
            # Prepare
            {inExtension,outExtension,file} = opts

            # Upper case the text document's content if it is using the convention txt.(uc|uppercase)
            return next() unless inExtension in ['coffee'] and outExtension in ['js',null]

            f = opts.templateData.document.fullPath
            dir = dirname f
            duo = Duo dir
            duo.use coffee
#            duo.development()
            duo.entry "#{basename f}.js"
            duo.src opts.content, inExtension
            duo.run (err, src) ->
                throw err if err?
                opts.content = src
                next()

coffee = (file, entry) ->
  return unless 'coffee' is file.type

  answer = coffeescript.compile file.src, sourceMap: true
  file.src = answer.js
  file.type = 'js'
  return file