fs = require 'fs';
protagonist = require 'protagonist';

bluefrisby = (configuration) ->
    frisby = configuration['frisby'] if configuration['frisby']
    protagonist = configuration['protagonist'] if configuration['protagonist']
    blueprintPath = configuration['blueprint_path'] if configuration['blueprint_path']
    base_url = configuration['base_url'] if configuration['base_url']

    if not blueprintPath?
      throw new Error "No blueprint path provided."

    if not base_url?
      throw new Error "No base URL provided."

    try
      data = fs.readFileSync blueprintPath, 'utf8'
    catch e
      throw e

    # Get JSON representation of the blueprint file
    ast = ""
    protagonist.parse data,  (error, result) ->
        if error? then throw error
        ast = result.ast


module.exports = bluefrisby
