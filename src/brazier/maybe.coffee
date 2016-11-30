maybeOps = {

  # Maybe Nothing
  None: {}

  # forall t. t -> Maybe t
  Something: (x) ->
    { _type: "something", _value: x }

  # forall t. (t -> Boolean) -> Maybe t -> Maybe t
  filter: (f) -> (maybe) ->
    maybeOps.flatMap((x) -> if f(x) then maybeOps.Something(x) else maybeOps.None)(maybe)

  # forall t u. (t -> Maybe u) -> Maybe t -> Maybe u
  flatMap: (f) -> (maybe) ->
    maybeOps.fold(-> maybeOps.None)(f)(maybe)

  # forall t u. (Unit -> u) -> (t -> u) -> Maybe t -> u
  fold: (ifNone) -> (ifSomething) -> (maybe) ->
    if maybeOps.isSomething(maybe) then ifSomething(maybe._value) else ifNone()

  # Maybe _ -> Boolean
  isSomething: ({ _type }) ->
    _type is "something"

  # forall t u. (t -> u) -> Maybe t -> Maybe u
  map: (f) -> (maybe) ->
    maybeOps.fold(-> maybeOps.None)((x) -> maybeOps.Something(f(x)))(maybe)

  # forall t. t -> Maybe t
  maybe: (x) ->
    if x? then maybeOps.Something(x) else maybeOps.None

  # forall t. Maybe t -> Array t
  toArray: (maybe) ->
    maybeOps.fold(-> [])((x) -> [x])(maybe)

}

module.exports = maybeOps
