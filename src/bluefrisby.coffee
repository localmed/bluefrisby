fs = require 'fs'

protagonist = require 'protagonist'
jasmine = require 'jasmine-node'
frisby = require 'frisby'

walker = require './walker'

bluefrisby = (configuration) ->
    frisby = configuration['frisby'] if configuration['frisby']
    protagonist = configuration['protagonist'] if configuration['protagonist']
    blueprint_path = configuration['blueprint_path'] if configuration['blueprint_path']
    base_url = configuration['base_url'] if configuration['base_url']

    if not blueprint_path?
      throw new Error "No blueprint path provided."

    if not base_url?
      throw new Error "No base URL provided."

    try
      data = fs.readFileSync blueprint_path, 'utf8'
    catch e
      throw e

    # Get JSON representation of the blueprint file
    ast_json = ""
    protagonist.parse data,  (error, result) ->
        if error? then throw error
        ast_json = result.ast

    # Walk AST, generate jasmine tests
    try
      walker frisby, base_url, ast_json['resourceGroups']
    catch error
      throw error

module.exports = bluefrisby
