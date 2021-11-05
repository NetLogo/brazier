# Number -> Number -> Number
multiply = (x) -> (y) ->
  x * y

# Number -> Number -> Number
plus = (x) -> (y) ->
  x + y

# Number -> Number -> Array Number
rangeTo = (start) -> (end) ->
  if start <= end
    [start..end]
  else
    []

# Number -> Number -> Array Number
rangeUntil = (start) -> (end) ->
  if start < end
    [start...end]
  else
    []

export { multiply, plus, rangeTo, rangeUntil }
