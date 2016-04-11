module.exports = {
  isArray:    (x) -> Array.isArray(x)
  isBoolean:  (x) -> typeof(x) is "boolean"
  isFunction: (x) -> typeof(x) is "function"
  isNumber:   (x) -> typeof(x) is "number" and not isNaN(x)
  isObject:   (x) -> typeof(x) is "object" and x isnt null and not Array.isArray(x)
  isString:   (x) -> typeof(x) is "string"
}
