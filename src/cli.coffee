protagonist = require '../lib/protagonist'
frisby = require '../lib/frisby'

cli = (configuration, callback) ->
  fs.readFile configuration['blueprintPath'], 'utf8', (error, data) ->
    if error
      cliUtils.error error
      cliUtils.exit 1
      callback()
    else
      protagonist.parse data, (error, result) ->
        if error
          cliUtils.error error
          cliUtils.exit 1
          callback()
        else
          nil

module.exports = cli
