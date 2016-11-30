module.exports = {

  # forall t u. (t -> u) -> t -> u
  apply: (f) -> (x) ->
    f(x)

  # forall t u v. (t -> u -> v) -> (u -> t -> v)
  flip: (f) ->
    (x) -> (y) -> f(y)(x)

  # forall t. t -> t
  id: (x) ->
    x

  # forall t. (t -> t)* -> (t -> t)
  pipeline: (functions...) ->
    (args...) ->
      [h, fs...] = functions
      out = h(args...)
      for f in fs
        out = f(out)
      out

}
