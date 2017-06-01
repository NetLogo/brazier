{ eq                     } = require('./equals')
{ maybe, None, Something } = require('./maybe')
{ isArray                } = require('./type')

arrayOps = {

  # forall t. (t -> Boolean) -> Array t -> Boolean
  all: (f) -> (arr) ->
    for x in arr
      if not f(x)
        return false
    true

  # forall t. Array t -> Array t -> Array t
  concat: (xs) -> (ys) ->
    xs.concat(ys)

  # forall t. t -> Array t -> Boolean
  contains: (x) -> (arr) ->
    for item in arr
      if eq(x)(item)
        return true
    false

  # forall t. (t -> String) -> Array t -> Object Number
  countBy: (f) -> (arr) ->
    acc = {}
    for x in arr
      key      = f(x)
      value    = acc[key] ? 0
      acc[key] = value + 1
    acc

  # forall t. Array t -> Array t -> Array t
  difference: (xs) -> (arr) ->
    acc     = []
    badBoys = arrayOps.unique(xs)
    for x in arr
      if not arrayOps.contains(x)(badBoys)
        acc.push(x)
    acc

  # forall t. (t -> Boolean) -> Array t -> Boolean
  exists: (f) -> (arr) ->
    for x in arr
      if f(x)
        return true
    false

  # forall t. (t -> Boolean) -> Array t -> Array t
  filter: (f) -> (arr) ->
    for x in arr when f(x)
      x

  # forall t. (t -> Boolean) -> Array t -> Maybe t
  find: (f) -> (arr) ->
    for x in arr
      if f(x)
        return Something(x)
    None

  # forall t. (t -> Boolean) -> Array t -> Maybe Number
  findIndex: (f) -> (arr) ->
    for x, i in arr
      if f(x)
        return Something(i)
    None

  # forall t u. (t -> Array u) -> Array t -> Array u
  flatMap: (f) -> (arr) ->
    arrs =
      for x in arr
        f(x)
    [].concat(arrs...)

  # forall t u. Array t -> Array u
  flattenDeep: (arr) ->
    acc = []
    for x in arr
      if isArray(x)
        acc = acc.concat(arrayOps.flattenDeep(x))
      else
        acc.push(x)
    acc

  # forall t u. (u,t -> u) -> u -> Array t -> u
  foldl: (f) -> (acc) -> (arr) ->
    out = acc
    for x in arr
      out = f(out, x)
    out

  # forall t. (t -> ()) -> Array t -> ()
  forEach: (f) -> (arr) ->
    for x in arr
      f(x)
    return

  # forall t. Array t -> Maybe t
  head: (arr) ->
    arrayOps.item(0)(arr)

  # forall t. Array t -> Boolean
  isEmpty: (arr) ->
    arr.length is 0

  # forall t. Number -> Array t -> Maybe t
  item: (index) -> (xs) ->
    if 0 <= index < xs.length then Something(xs[index]) else None

  # forall t. Array t -> t
  last: (arr) ->
    arr[arr.length - 1]

  # forall t. Array t -> Number
  length: (arr) ->
    arr.length

  # forall t u. (t -> u) -> Array t -> Array u
  map: (f) -> (arr) ->
    for x in arr
      f(x)

  # forall t. (t -> Number) -> Array t -> t
  maxBy: (f) -> (arr) ->
    maxX = undefined
    maxY = -Infinity
    for x in arr
      y = f(x)
      if y > maxY
        maxX = x
        maxY = y
    maybe(maxX)

  # forall t. Array t -> Array t
  reverse: (xs) ->
    xs[..].reverse()

  # forall t. t -> Array t
  singleton: (x) ->
    [x]

  # forall t. (t -> Comparable) -> Array t -> Array t
  sortBy: (f) -> (arr) ->
    g = (x, y) ->
      fx = f(x)
      fy = f(y)
      if fx < fy then -1 else if fx > fy then 1 else 0
    arr.slice(0).sort(g)

  # forall t. (t -> Comparable) -> Array t -> t -> Number
  # Assumes that `arr` is already sorted in terms of `f`
  sortedIndexBy: (f) -> (arr) -> (x) ->
    y = f(x)
    for item, i in arr
      if y <= f(item)
        return i
    arr.length

  # forall t. Array t -> Array t
  tail: (arr) ->
    arr.slice(1)

  # forall t. Array (String, t) -> Object t
  toObject: (arr) ->
    out = {}
    for [a, b] in arr
      out[a] = b
    out

  # forall t. Array t -> Array t
  unique: (arr) ->
    acc = []
    for x in arr
      if not arrayOps.contains(x)(acc)
        acc.push(x)
    acc

  # forall t u. (t -> u) -> Array t -> Array t
  uniqueBy: (f) -> (arr) ->
    acc  = []
    seen = []
    for x in arr
      y = f(x)
      if not arrayOps.contains(y)(seen)
        seen.push(y)
        acc.push(x)
    acc

  # forall t u. Array t -> Array u -> Array (t, u)
  zip: (xs) -> (arr) ->
    out    = []
    length = Math.min(xs.length, arr.length)
    for i in [0...length]
      out.push([xs[i], arr[i]])
    out

}

module.exports = arrayOps
