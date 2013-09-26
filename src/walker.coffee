inheritHeaders = require './inherit-headers'
inheritParameters = require './inherit-parameters'
expandUriTemplateWithParameters = require './expand-uri-template-with-parameters'
exampleToHttpPayloadPair = require './example-to-http-payload-pair'
jsonTypeTransformer = require './jsonTypeTransformer'

walker = (frisby, baseUrl, resourceGroups) ->
  for group in resourceGroups
    for resource in group['resources']
      for action  in resource['actions']

        # headers and parameters can be specified higher up in the ast and inherited
        action['headers'] = inheritHeaders action['headers'], resource['headers']
        action['parameters'] = inheritParameters action['parameters'], resource['parameters']

        # uris are specified with {params} that need to be populated
        uriResult = expandUriTemplateWithParameters resource['uriTemplate'], action['parameters']

        if uriResult['uri']?
          fullUrl = baseUrl + uriResult['uri']

          # the tests are generated from the example responses from the ast
          for example in action['examples']

            payload = exampleToHttpPayloadPair example, action['headers']
            expectedResponse = payload['pair']['response']
            parsedRequest = payload['pair']['request']

            request = frisby.create(action.description)

            # add headers and change request type to json if necessary (defaults to form encoded)
            isJson = false
            for header, value of parsedRequest.headers
              request.addHeader(header, value['value'])
              if value['value'] is "application/json"
                isJson = true

            switch action.method
              when 'GET'
                request = request.get(fullUrl, {json: isJson})
              when 'POST'
                request = request.post(fullUrl, parsedRequest['body'], { json: isJson} )
              when 'PUT'
                request = request.put(fullUrl, parsedRequest['body'], { json: isJson } )
              when 'DELETE'
                request = request.delete(fullUrl, parsedRequest['body'],  { json: isJson} )
              when 'PATCH'
                request = request.patch(fullUrl, parsedRequest['body'],  { json: isJson} )

            request.expectStatus(parseInt expectedResponse['status'], 10)

            # check the response contains all expected headers
            for header, value of expectedResponse.headers
              request.expectHeaderContains header, value['value']

            # check that the keys are what they should be and the values are the correct type
            request.expectJSONTypes jsonTypeTransformer(expectedResponse.body)

            request.toss()

module.exports = walker
