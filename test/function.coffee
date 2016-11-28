{ arrayEquals, booleanEquals, numberEquals, objectEquals, stringEquals } = require('brazier/equals')
{ flip, id, pipeline }                                                   = require('brazier/function')

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

QUnit.test("Function: flip", (assert) ->

  add      = (x) -> (y) -> x + y      # Commutative
  subtract = (x) -> (y) -> x - y      # Not commutative
  concat   = (x) -> (y) -> "#{x}#{y}" # Not commutative

  assert.deepEqual(flip(     add)(1)(5),      add(1)(5))
  assert.deepEqual(flip(subtract)(1)(5), subtract(5)(1))

  assert.deepEqual(flip(concat)("apples")("oranges"), concat("oranges")("apples"))

)

QUnit.test("Function: id", (assert) ->

  pairs =
    [
      [arrayEquals,   arrayValues]
    , [booleanEquals, booleanValues]
    , [numberEquals,  numberValues]
    , [objectEquals,  objectValues]
    , [stringEquals,  stringValues]
    ]

  for [equals, vs] in pairs
    for v in vs
      assert.ok(equals(v)(id(v)) is true)

)

QUnit.test("Function: pipeline", (assert) ->

  plusOne  = (x) -> x + 1
  double   = (x) -> x * 2
  toString = (x) -> x.toString()

  assert.deepEqual(pipeline(toString)("appleseed"), "appleseed")
  assert.deepEqual(pipeline(toString, toString, toString, toString, toString)("apples"), "apples")
  assert.deepEqual(pipeline(double)(1), 2)
  assert.deepEqual(pipeline(double, double, double, double, double, double)(1), 64)
  assert.deepEqual(pipeline(double, plusOne, double)(1), 6)
  assert.deepEqual(pipeline(double, plusOne, double, toString)(1), "6")

)
