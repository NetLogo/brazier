module.exports = {

  # forall t. Object t -> Object t
  clone: (obj) ->
    acc  = {}
    keys = Object.keys(obj)
    for i in [0...(keys.length)]
      key      = keys[i]
      acc[key] = obj[key]
    acc

  # Object _ -> Array String
  keys: (obj) ->
    Object.keys(obj)

  # forall t. Object t -> Array (String, t)
  pairs: (obj) ->
    keys = Object.keys(obj)
    for i in [0...(keys.length)]
      key = keys[i]
      [key, obj[key]]

  # forall t. Object t -> Array t
  values: (obj) ->
    keys = Object.keys(obj)
    for i in [0...(keys.length)]
      obj[keys[i]]

}
