{ arrayEquals, booleanEquals, numberEquals, objectEquals, stringEquals } = require('brazier/equals')
{ pipeline                                                             } = require('brazier/function')
{ filter, flatMap, fold, isSomething, Something, map, None, toArray    } = require('brazier/maybe')

exploder = (x) -> throw new Error("This code should not get run.")

### BEGIN DATA ###

booleanValues = [true, false]

negativeInfinity = -Infinity
minNumber        = Number.MIN_VALUE
negativeNumber   = -10
zeroNumber       = 0
positiveNumber   = 9001
maxNumber        = Number.MAX_VALUE
infinity         = Infinity
numberValues     = [negativeInfinity, minNumber, negativeNumber, zeroNumber, positiveNumber, maxNumber, infinity]

emptyString     = ""
singletonString = "x"
normalString    = "lorem ipsum magico crapjico"
longString      = ("apples" for x in [1...1e6]).join()
stringValues    = [emptyString, singletonString, normalString, longString]

emptyArray     = []
singletonArray = [1]
numberArray    = [1..10]
unorderedArray = [1,9,2,5,3,8,17,209,32,1,3]
mixedArray     = [true, 19, "apples", "oranges", {}, false, [], [1,2,3], {a: 10}, "grapes", -10]
longArray      = (1 for x in [1...1e6])
arrayValues    = [emptyArray, singletonArray, numberArray, unorderedArray, mixedArray, longArray]

emptyObject  = {}
normalObject = { a: 1, b: "apples" }
nestedObject = { a: normalObject, z: emptyObject, g: { apples: "grapes" } }
newObject    = new Object()
objectValues = [emptyObject, normalObject, nestedObject, newObject]

### END DATA ###

QUnit.test("Maybe: filter", (assert) ->

  test =
    (maybe, f, expected) ->
      assert.deepEqual(filter(f)(maybe), expected)

  test(None, ((x) -> throw new Exception("BOOM!  HAHAHA!")), None)
  test(None, ((x) ->                                  true), None)
  test(None, ((x) ->                                 false), None)

  test(Something("apples"), ((x) ->  true), Something("apples"))
  test(Something("apples"), ((x) -> false), None)

  test(Something(3), ((x) ->  true), Something(3))
  test(Something(3), ((x) -> false), None)

  test(Something(true), ((x) ->  true), Something(true))
  test(Something(true), ((x) -> false), None)

  test(Something({}), ((x) ->  true), Something({}))
  test(Something({}), ((x) -> false), None)

  test(Something("apples"), ((x) -> x.length is 3),  None)
  test(Something("apples"), ((x) -> x.length is 6),  Something("apples"))
  test(Something("apples"), ((x) -> x is "apples"),  Something("apples"))
  test(Something("apples"), ((x) -> x is "oranges"), None)
  test(Something("apples"), ((x) -> x[3] is "l"),    Something("apples"))
  test(Something("apples"), ((x) -> x[3] is "p"),    None)

)

QUnit.test("Maybe: flatMap", (assert) ->

  test =
    (maybe, f, expected) ->
      assert.deepEqual(flatMap(f)(maybe), expected)

  test(None, exploder, None)

  test(Something(0), ((x) -> None), None)

  test(Something(0), ((x) -> if x %% 2 is 0 then Something("me") else None), Something("me"))
  test(Something(1), ((x) -> if x %% 2 is 0 then Something("me") else None),            None)

  test(Something(Something("apples")), ((x) -> x), Something("apples"))

  test(Something( "apples"), ((x) -> if x.length isnt 7 then Something(x) else None), Something("apples"))
  test(Something( "grapes"), ((x) -> if x.length isnt 7 then Something(x) else None), Something("grapes"))
  test(Something("oranges"), ((x) -> if x.length isnt 7 then Something(x) else None),                None)
  test(Something("bananas"), ((x) -> if x.length isnt 7 then Something(x) else None),                None)

  # Monad law tests below

  point        = Something
  f            = (x) -> point("#{x}!")
  g            = (x) -> point("#{x}?")
  h            = (x) -> point("#{x}~")
  shortCircuit = (x) -> None

  item    = "apples"
  wrapped = Something(item)

  # Kleisli Arrow / Kleisli composition operator
  kleisli =
    (f1) -> (f2) -> (x) ->
      flatMap(f2)(f1(x))

  fgh1 = kleisli(kleisli(f)(g))(h)
  fgh2 = kleisli(f)(kleisli(g)(h))

  sgh = kleisli(shortCircuit)(kleisli(g)(h))
  fsh = kleisli(f)(kleisli(shortCircuit)(h))
  fgs = kleisli(f)(kleisli(g)(shortCircuit))

  test(point(item), f,     f(item))                                # Left identity
  test(wrapped,     point, wrapped)                                # Right identity
  assert.deepEqual(flatMap(fgh1)(wrapped), flatMap(fgh2)(wrapped)) # Associativity

  assert.deepEqual(flatMap(sgh)(wrapped), None) # Associative short circuiting #1
  assert.deepEqual(flatMap(fsh)(wrapped), None) # Associative short circuiting #2
  assert.deepEqual(flatMap(fgs)(wrapped), None) # Associative short circuiting #3

)

QUnit.test("Maybe: fold", (assert) ->

  test =
    (maybe, f, g, expected) ->
      assert.deepEqual(fold(f)(g)(maybe), expected)

  test(None, (->        3),           exploder,        3)
  test(None, (-> "apples"),           exploder, "apples")
  test(None, (-> "apples"), ((x) -> "oranges"), "apples")

  test(Something(9001), (-> -1),    ((x) -> x / 10), 9001 / 10)
  test(Something( -11), (-> -1),    ((x) -> x / 10),  -11 / 10)
  test(Something(   0), (-> false), ((x) -> x is 0),      true)

  test(Something( true), (-> false), ((x) ->     x),  true)
  test(Something( true), (-> false), ((x) -> not x), false)
  test(Something(false), (-> false), ((x) -> not x),  true)

  test(Something( "apples"), (-> 0), ((x) -> x.length), 6)
  test(Something("bananas"), (-> 0), ((x) -> x.length), 7)

  test(Something([     ]), (-> -1), ((x) -> x.length), 0)
  test(Something([1..10]), (-> -9), ((x) ->     x[2]), 3)

  test(Something({                   }), (-> ["none"]), ((x) ->  Object.keys(x)), [])
  test(Something({ daysThisMonth: 28 }), (-> 30),       ((x) -> x.daysThisMonth), 28)

)

QUnit.test("Maybe: isSomething", (assert) ->

  test =
    (maybe, expected) ->
      assert.deepEqual(isSomething(maybe), expected)

  test(None, false)

  test(Something(   3),  true)
  test(Something(true),  true)
  test(Something(  {}),  true)

  test(   3, false)
  test(true, false)
  test(  {}, false)

)

QUnit.test("Maybe: map", (assert) ->

  test =
    (maybe, f, expected) ->
      assert.deepEqual(map(f)(maybe), expected)

  test(None,              exploder, None)
  test(None, ((x) -> x.toString()), None)
  test(None, (    ->         9001), None)

  test(Something(true), (-> 9001), Something(9001))
  test(Something(   3), (-> 9001), Something(9001))

  test(Something(    7), ((x) -> x + 1), Something(    8))
  test(Something(-3001), ((x) -> x + 1), Something(-3000))
  test(Something(    7), ((x) -> x * 2), Something(   14))
  test(Something(-3001), ((x) -> x * 2), Something(-6002))

  test(Something( true), ((x) -> x), Something( true))
  test(Something(false), ((x) -> x), Something(false))

  test(Something("oranges"), ((x) -> x.length), Something( 7 ))
  test(Something(  "merpy"), ((x) -> x.length), Something( 5 ))
  test(Something( "gurpy!"), ((x) -> x.length), Something( 6 ))
  test(Something("oranges"), ((x) -> x[0]),     Something("o"))
  test(Something(  "merpy"), ((x) -> x[0]),     Something("m"))
  test(Something( "gurpy!"), ((x) -> x[0]),     Something("g"))

  test(Something([13..19]), ((x) -> x?),                    Something( true))
  test(Something([13..19]), ((x) -> not x?),                Something(false))
  test(Something([13..19]), ((x) -> x is undefined),        Something(false))
  test(Something([13..19]), ((x) -> x is false),            Something(false))
  test(Something([13..19]), ((x) -> (x ? {}).length > 3),   Something( true))
  test(Something([13..19]), ((x) -> typeof(x) is 'object'), Something( true))

  test(Something(null), ((x) -> x?),                    Something(false))
  test(Something(null), ((x) -> not x?),                Something( true))
  test(Something(null), ((x) -> x is undefined),        Something(false))
  test(Something(null), ((x) -> x is false),            Something(false))
  test(Something(null), ((x) -> (x ? {}).length > 3),   Something(false))
  test(Something(null), ((x) -> typeof(x) is 'object'), Something( true))

  test(Something({ apples: 3 }), ((x) -> x?),                    Something( true))
  test(Something({ apples: 3 }), ((x) -> not x?),                Something(false))
  test(Something({ apples: 3 }), ((x) -> x is undefined),        Something(false))
  test(Something({ apples: 3 }), ((x) -> x is false),            Something(false))
  test(Something({ apples: 3 }), ((x) -> (x ? {}).length > 3),   Something(false))
  test(Something({ apples: 3 }), ((x) -> typeof(x) is 'object'), Something( true))

  # Functor laws!

  f     = (x) -> "#{x}!"
  g     = (x) -> "#{x}?"
  id    = (x) -> x
  maybe = Something("bananas")

  mapTwice    = pipeline(map(f), map(g))
  mapComposed = map(pipeline(f, g))

  test(maybe, id, maybe)                                # Identity
  assert.deepEqual(mapTwice(maybe), mapComposed(maybe)) # Associativity

)

QUnit.test("Maybe: toArray", (assert) ->

  pairs =
    [
      [arrayEquals,   arrayValues]
    , [booleanEquals, booleanValues]
    , [numberEquals,  numberValues]
    , [objectEquals,  objectValues]
    , [stringEquals,  stringValues]
    ]

  assert.deepEqual(toArray(None), [])

  for [f, vs] in pairs
    for v in vs
      result = toArray(Something(v))
      assert.ok(result.length is 1)
      assert.ok(f(v)(result[0]))

)
