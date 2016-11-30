module.exports = {

  # forall t u. (t -> u) -> t -> u
  apply: (f) -> (x) ->
    f(x)

  # forall t. t -> Unit -> t
  constantly: (x) ->
    -> x

  # Function? -> (? -> ?)
  curry: (f) ->
    argsToArray = (args) -> Array.prototype.slice.call(args, 0)
    curryMaster = ->
      argsThusFar = argsToArray(arguments)
      if argsThusFar.length >= f.length
        f(argsThusFar...)
      else
        ->
          nextTierArgs = argsToArray(arguments)
          curryMaster(argsThusFar.concat(nextTierArgs)...)
    curryMaster

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

  # (? -> ?) -> Function?
  uncurry: (f) ->
    (args...) ->
      args.reduce(((acc, arg) -> acc(arg)), f)

}
