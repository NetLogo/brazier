# Maybe Nothing
None = {}

# forall t. t -> Maybe t
Something = (x) ->
  { _type: "something", _value: x }

# forall t. (t -> Boolean) -> Maybe t -> Maybe t
filter = (f) -> (maybe) ->
  flatMap((x) -> if f(x) then Something(x) else None)(maybe)

# forall t u. (t -> Maybe u) -> Maybe t -> Maybe u
flatMap = (f) -> (maybe) ->
  fold(-> None)(f)(maybe)

# forall t u. (Unit -> u) -> (t -> u) -> Maybe t -> u
fold = (ifNone) -> (ifSomething) -> (maybe) ->
  if isSomething(maybe) then ifSomething(maybe._value) else ifNone()

# Maybe _ -> Boolean
isSomething = ({ _type }) ->
  _type is "something"

# forall t u. (t -> u) -> Maybe t -> Maybe u
map = (f) -> (maybe) ->
  fold(-> None)((x) -> Something(f(x)))(maybe)

# forall t. t -> Maybe t
maybe = (x) ->
  if x? then Something(x) else None

# forall t. Maybe t -> Array t
toArray = (maybe) ->
  fold(-> [])((x) -> [x])(maybe)

export { filter, flatMap, fold, isSomething, map, maybe, None, Something, toArray }
