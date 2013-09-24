cliUtils = require './cli-utils'
bluefrisby = require './bluefrisby'

cli = (configuration, callback) ->
  try
    bluefrisby configuration
    callback
  catch error
    cliUtils.error error
    cliUtils.exit 1
    callback

module.exports = cli
