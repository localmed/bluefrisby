# BlueFrisby.js

Bluefrisby.js is a [node.js](http://nodejs.org/) [npm](https://npmjs.org/) module that tests your api specification against your backend implementation. Document your API in the [API blueprint](http://apiblueprint.org/) format, and bluefrisby will automatically generate tests for your API. Your tests have the simplicity of [frisby.js](http://frisbyjs.com) with all of the power and flexibility of [jasmine-node](https://github.com/mhevery/jasmine-node).

# Install

Bluefrisby.js requires node.js, npm, and jasmine-node.

    npm install -g bluefrisby
    
# Usage

Create a file called `api_spec.js` or `api_spec.coffee`. The filename must end in `_spec` and be either js or coffeescript.

### Sample api_spec.js

    var bluefrisby = require('bluefrisby');

    bluefrisby({
      blueprint_path: __dirname + "/../test/test.apib",
      base_url: "https://alpha-api.app.net"
    });
    
### Sample api_spec.coffee
    bluefrisby = require 'bluefrisby'

    bluefrisby {
        blueprint_path: __dirname + "/path/to/blueprint.md", 
        base_url: "https://myapisite.com"
    }
    
### Run tests

Bluefrisby generates valid jasmine tests that can be run with the jasmine-node command:

    jasmine-node --coffee specs/
   
where `specs` is a folder containing api_spec.js. Jasmine will find all files ending in _spec and run them.
    
# Advanced options
	
Bluefrisby is dependency injected, completely exposing both frisby.js and protagonist for configuration.

### Sample api_spec.coffee with global auth header

    bluefrisby = require 'bluefrisby'
    frisby = require 'frisby'
    
    frisby.globalSetup { 
        request: {
            headers: { 
                'X-Auth-Token': 'fake-auth-key' 
            }
        }
    }

    bluefrisby {
        blueprint_path: __dirname + "/path/to/blueprint.md",
        base_url: "https://myapisite.com", 
        frisby: frisby 
    }
    
Since your `_spec` file is simply run by jasmine-node, you can include any valid frisby or jasmine test in your file and it will run with the rest! This is useful if you need to test specific edge cases, or do more in-depth inspection and validation. Or you can keep your non-generated tests in separate `_spec` files, and as long as they're in the same folder, jasmine will run them.

# Run examples

Install the necessary node modules globally:
    
    node install -g frisby
    node install -g jasmine-node
    
Run the example

    cd /path/to/bluefrisby/root
    jasmine-node --coffee examples/test/
    
You should see one failing test and several passing tests.

**Excecise** *Change test_spec.apib to make all the tests pass with the fewest changes possible.*

# Coming Soon

Path-based custom response validation. Passes request up to a router which appends your custom frisby tests to the generated request. This should be much easier than adding your own frisby tests simply for basic validation.

# Caveats

 * Bluefrisby can only generate tests for resources with enough information to perform validations. This means example data and expected responses.
 * At the moment, the data in json arrays is not validated by default, simply that it is an array.
 * Models in the api blueprint are unsupported for now. It's currently unclear whether this should be handled by protagonist or bluefrisby.
