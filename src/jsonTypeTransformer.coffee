jsonTypeTransformer = (object) ->
  transformed = JSON.parse object, (key, value) ->
    # frisby expects the actual types and not strings
    # objects and functions return by value (for nesting and custom validators, respectively)
    switch  typeof value
      when 'object'
        return value
      when 'string'
        return String
      when 'number'
        return Number
      when 'boolean'
        return Boolean
      when 'function'
        return value

    # this catches undefined, xml, and any implementation-specific types and removes them
    return undefined

  return transformed


module.exports = jsonTypeTransformer
