import { QUnit } from '/test/target/qunit/qunit.js'

import { isArray, isBoolean, isFunction, isNumber, isObject, isString } from '/target/brazier/brazier/type.js'

### BEGIN DATA ###

crapValues = [undefined, null, NaN]

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

noopFunction     = (->)
identityFunction = (x) -> x
doublerFunction  = (x) -> x * 2
splatFunction    = (xs...) -> xs.reduce((a, b) -> a + b)
functionValues   = [noopFunction, identityFunction, doublerFunction, splatFunction]

allValues = [].concat(crapValues, booleanValues, numberValues, stringValues, arrayValues, objectValues, functionValues)

### END DATA ###

forAll = (f) -> (xs) ->
  for x in xs when not f(x)
    return false
  true

forNone = (f) -> (xs) ->
  for x in xs when f(x)
    return false
  true

without = (undesirables) -> (xs) ->
  xs.filter((x) -> undesirables.indexOf(x) is -1)

QUnit.test("Typechecking", (assert) ->

  test = (goods) -> (f) ->
    bads = without(goods)(allValues)
    assert.ok(forAll (f)(goods) is true)
    assert.ok(forNone(f)( bads) is true)

  pairs =
    [
      [arrayValues,    isArray]
    , [booleanValues,  isBoolean]
    , [functionValues, isFunction]
    , [numberValues,   isNumber]
    , [objectValues,   isObject]
    , [stringValues,   isString]
    ]

  for [values, f] in pairs
    test(values)(f)

)
