module.exports = {

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
