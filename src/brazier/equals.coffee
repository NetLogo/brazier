import { isArray, isBoolean, isNumber, isObject, isString } from './type.js'

# forall t. Array t -> Array t -> Boolean
arrayEquals = (x) -> (y) ->
  helper =
    (a, b) ->
      for item, index in a when not eq(item)(b[index])
        return false
      true
  (x is y) or (x.length is y.length and helper(x, y))

# Boolean -> Boolean -> Boolean
booleanEquals = (x) -> (y) ->
  x is y

# Any -> Any -> Boolean
eq = (x) -> (y) ->
  (x is y) or
    (x is undefined and y is undefined) or
      (x is null and y is null) or
        (isNumber(x) and isNumber(y) and ((isNaN(x) and isNaN(y)) or numberEquals(x)(y))) or
          (isBoolean(x) and isBoolean(y) and booleanEquals(x)(y)) or
            (isString(x) and isString(y) and stringEquals(x)(y)) or
              (isObject(x) and isObject(y) and objectEquals(x)(y)) or
                (isArray(x) and isArray(y) and arrayEquals(x)(y))

# Number -> Number -> Boolean
numberEquals = (x) -> (y) ->
  x is y

# forall t. Object t -> Object t -> Boolean
objectEquals = (x) -> (y) ->
  xKeys = Object.keys(x)
  helper =
    (a, b) ->
      for i in [0...(xKeys.length)]
        key = xKeys[i]
        if not eq(x[key])(y[key])
          return false
      true
  (x is y) or (xKeys.length is Object.keys(y).length and helper(x, y))

# String -> String -> Boolean
stringEquals = (x) -> (y) ->
  x is y

export {
  arrayEquals
  booleanEquals
  eq
  numberEquals
  objectEquals
  stringEquals
}
