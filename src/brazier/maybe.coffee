maybeOps = {

  # Maybe Nothing
  None: {}

  # forall t. t -> Maybe t
  Something: (x) ->
    { type: "something", value: x }

  # forall t u. (t -> Maybe u) -> Maybe t -> Maybe u
  flatMap: (f) -> (maybe) ->
    maybeOps.fold(-> maybeOps.None)(f)(maybe)

  # forall t u. (Unit -> u) -> (t -> u) -> Maybe t -> u
  fold: (ifNone) -> (ifSomething) -> (maybe) ->
    if maybeOps.isSomething(maybe) then ifSomething(maybe.value) else ifNone()

  # Maybe _ -> Boolean
  isSomething: ({ type }) ->
    type is "something"

  # forall t u. (t -> u) -> Maybe t -> Maybe u
  map: (f) -> (maybe) ->
    maybeOps.fold(-> maybeOps.None)((x) -> maybeOps.Something(f(x)))(maybe)

  # forall t. Maybe t -> Array t
  toArray: (maybe) ->
    maybeOps.fold(-> [])((x) -> [x])(maybe)

}

module.exports = maybeOps
