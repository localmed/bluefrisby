#bluefrisby = require 'bluefrisby'
frisby = require 'frisby'

frisby.globalSetup {
  request: {
    headers: { 'X-Auth-Token': 'fake-auth-token' }
  }
}

try
  bluefrisby({blueprint_path: __dirname + "./test.apib", base_url: "https://alpha-api.app.net", frisby: frisby})
catch error
  console.log error
