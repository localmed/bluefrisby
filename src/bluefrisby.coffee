fs = require 'fs';
protagonist = require 'protagonist';
jasmine = require 'jasmine-node';
frisby = require 'frisby';
deleteFolderRecursive = require './deleteFolderRecursive'
string = require 'string'
util = require 'util'

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

    # Clean up directories
    if fs.existsSync(__dirname + "/../specs/")
      deleteFolderRecursive(__dirname + "/../specs/")
    fs.mkdirSync(__dirname + "/../specs/")

    test_string = "var frisby = require('frisby')\n"
    # Walk AST, generate jasmine tests
    for group in ast_json['resourceGroups']
      for resource in group.resources
        for action  in resource.actions
          console.log("Action: " + JSON.stringify(action) + "\n --------- \n")
          try
            test = frisby.create('Get Brightbit Twitter feed')
              .get('https://api.twitter.com/1/statuses/user_timeline.json?screen_name=brightbit')
              .expectStatus(200)
              .expectHeaderContains('content-type', 'application/json')
              .expectJSON('0', {
                place: (val) -> expect(val).toMatchOrBeNull("Oklahoma City, OK"),
                user: {
                  verified: false,
                  location: "Oklahoma City, OK",
                  url: "http://brightb.it"
                }
              })
              .expectJSONTypes('0', {
                id_str: String,
                retweeted: Boolean,
                in_reply_to_screen_name: (val) -> expect(val).toBeTypeOrNull(String),
                user: {
                  verified: Boolean,
                  location: String,
                  url: String
                }})
            console.log(JSON.stringify(test))
            test_string +=  ("\nfrisby.create(JSON.parse(" + JSON.stringify(test) + ").toss()")
          catch err
            console.log("Error: " + err)

          fs.writeFile __dirname + "/../specs/" + string((blueprint_path.split(".")[0]).split("/").pop()).underscore().s + "_spec.js", test_string, 'utf8', (err) ->
              if err
                console.log(err)
              else
                console.log("The file was saved!")


module.exports = bluefrisby
