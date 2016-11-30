{ all, concat, contains, countBy, difference, exists, filter, find, findIndex, flatMap, flattenDeep, foldl, forEach, head, headAndTail, isEmpty, item, last, length, map, maxBy, sortBy, sortedIndexBy, tail, toObject, unique, uniqueBy, zip } = require('brazier/array')
{ id, pipeline } = require('brazier/function')

exploder = (x) -> throw new Error("This code should not get run.")

QUnit.test("Array: all", (assert) ->

  testGreaterThan10 =
    (input, expected) ->
      assert.deepEqual(all((x) -> x > 10)(input), expected)

  testGreaterThan10([],       true)
  testGreaterThan10([1],      false)
  testGreaterThan10(["merp"], false)
  testGreaterThan10([11],     true)
  testGreaterThan10([13..19], true)
  testGreaterThan10([10..20], false)

  testAtLeast3Elems =
    (input, expected) ->
      assert.deepEqual(all((x) -> x.length >= 3)(input), expected)

  testAtLeast3Elems([],                           true)
  testAtLeast3Elems([1],                          false)
  testAtLeast3Elems([[13..19]],                   true)
  testAtLeast3Elems([[13..19], [10..30], [1..3]], true)
  testAtLeast3Elems([[13..19], [10..10], [1..3]], false)
  testAtLeast3Elems(["merp"],                     true)
  testAtLeast3Elems(["merpy", "gurpy"],           true)
  testAtLeast3Elems(["ep", "merpy", "gurpy"],     false)
  testAtLeast3Elems([[13..19], "dreq", [1..3]],   true)

  assert.deepEqual(all(exploder)([]), true)

)

QUnit.test("Array: concat", (assert) ->

  test =
    (ys, xs, expected) ->
      assert.deepEqual(concat(ys)(xs), expected)

  test([1],        [],                   [1])
  test([],         [976],                [976])
  test([5],        [1],                  [1, 5])
  test([[3..6]],   [[13..19]],           [[13..19], [3..6]])
  test([17],       [13..19],             [13, 14, 15, 16, 17, 18, 19, 17])
  test(["merp"],   ["merpy", "gurpy"],   ["merpy", "gurpy", "merp"])
  test([9001],     ["merpy", "gurpy"],   ["merpy", "gurpy", 9001])
  test([3..6],     [13..19],             [13, 14, 15, 16, 17, 18, 19, 3, 4, 5, 6])

)

QUnit.test("Array: contains", (assert) ->

  test =
    (input, x, expected) ->
      assert.deepEqual(contains(x)(input), expected)

  test([],                         1,        false)
  test([1],                        1,        true)
  test([[13..19]],                 [13..19], true)
  test([13..19],                   17,       true)
  test(["merpy", "gurpy"],         "merp",   false)
  test(["merpy", "gurpy"],         "merpy",  true)
  test(["merpy", "gurpy"],         "gurpy",  true)
  test([[13..19], "dreq", [1..3]], "dreq",   true)

)

QUnit.test("Array: countBy", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(countBy(f)(xs), expected)

  test([1..10], ((x) -> x is 0), { false: 10 })
  test([1..10], ((x) -> x is 1), { true: 1, false: 9 })
  test([1..10], ((x) -> x),      { 1: 1, 2: 1, 3: 1, 4: 1, 5: 1, 6: 1, 7: 1, 8: 1, 9: 1, 10: 1 })
  test([1..10], ((x) -> x %% 3), { 1: 4, 2: 3, 0: 3 })

  test([false, false, false], ((x) -> not x),  { true:  3 })
  test([false, false, false], ((x) -> x),      { false: 3 })
  test([true,  true,  true ], ((x) -> not x),  { false: 3 })
  test([true,  false, false], ((x) -> x),      { true:  1, false: 2 })
  test([true,  false, false], ((x) -> not x),  { false: 1, true:  2 })
  test([true,  false, false], ((x) -> not x?), { false: 3 })

  test(["merpy", "gurpy"], ((x) -> x.length),      { 5: 2 })
  test(["merpy", "gurpy"], ((x) -> x.length > 10), { false: 2 })
  test(["merpy", "gurpy"], ((x) -> x[0] is "m"),   { true: 1, false: 1 })
  test(["merpy", "gurpy"], ((x) -> x[0] is "g"),   { false: 1, true: 1})
  test(["merpy", "gurpy"], ((x) -> x[0] is "x"),   { false: 2 })

  test([], (-> true),  {})
  test([], (-> false), {})
  test([], exploder,   {})

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> x?),               { true: 6, false: 1 })
  test(megalist, ((x) -> x is undefined),   { false: 7 })
  test(megalist, ((x) -> not x),            { false: 5, true: 2 })
  test(megalist, ((x) -> (x ? {}).length?), { true: 3, false: 4 })
  test(megalist, ((x) -> typeof(x)),        { object: 4, boolean: 1, number: 1, string: 1 })

)

QUnit.test("Array: difference", (assert) ->

  test =
    (xs, ys, expected) ->
      assert.deepEqual(difference(ys)(xs), expected)

  test([],                         [],        [])
  test([1],                        [],        [1])
  test([13..19],                   [],        [13..19])
  test([13..19],                   [14..19],  [13])
  test([14..19],                   [13..19],  [])
  test([13..19],                   [17],      [13, 14, 15, 16, 18, 19])
  test([false, false, false],      [false],   [])
  test([true, false, false],       [false],   [true])
  test(["merpy", "gurpy"],         ["merp"],  ["merpy", "gurpy"])
  test(["merpy", "gurpy"],         ["merpy"], ["gurpy"])
  test([[13..19], "dreq", [1..3]], ["dreq"],  [[13..19], [1..3]])

)

QUnit.test("Array: exists", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(exists(f)(xs), expected)

  test([1..10], ((x) -> x is    0     ), false)
  test([1..10], ((x) -> x is    1     ), true)
  test([1..10], ((x) -> x is    3     ), true)
  test([1..10], ((x) -> x is   10     ), true)
  test([1..10], ((x) -> x is   11     ), false)
  test([1..10], ((x) -> x  <    0     ), false)
  test([1..10], ((x) -> x  < 9001     ), true)
  test([1..10], ((x) -> x %%    2 is 0), true)
  test([1..10], ((x) -> x %%    6 is 0), true)
  test([1..10], ((x) -> x %%   15 is 0), false)

  test([false, false, false], ((x) -> not x),  true)
  test([false, false, false], ((x) -> x),      false)
  test([true,  true,  true ], ((x) -> not x),  false)
  test([true,  false, false], ((x) -> x),      true)
  test([true,  false, false], ((x) -> not x),  true)
  test([true,  false, false], ((x) -> not x?), false)

  test(["merpy", "gurpy"], ((x) -> x.length is 5), true)
  test(["merpy", "gurpy"], ((x) -> x.length > 10), false)
  test(["merpy", "gurpy"], ((x) -> x[0] is "m"),   true)
  test(["merpy", "gurpy"], ((x) -> x[0] is "g"),   true)
  test(["merpy", "gurpy"], ((x) -> x[0] is "x"),   false)

  test([], (-> true),  false)
  test([], (-> false), false)
  test([], exploder,   false)

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> x?),                      true)
  test(megalist, ((x) -> not x?),                  true)
  test(megalist, ((x) -> x is undefined),          false)
  test(megalist, ((x) -> x is true),               false)
  test(megalist, ((x) -> x is false),              true)
  test(megalist, ((x) -> (x ? {})[1] is 2),        true)
  test(megalist, ((x) -> (x ? {}).length > 10),    false)
  test(megalist, ((x) -> (x ? {}).length is 4),    true)
  test(megalist, ((x) -> (x ? {}).length > 4),     true)
  test(megalist, ((x) -> (x ? {}).apples?),        true)
  test(megalist, ((x) -> (x ? {}).apples is 4),    false)
  test(megalist, ((x) -> x is "dreq"),             true)
  test(megalist, ((x) -> x is "grek"),             false)
  test(megalist, ((x) -> x > 10 < 30),             true)
  test(megalist, ((x) -> typeof(x) isnt 'object'), true)

)

QUnit.test("Array: filter", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(filter(f)(xs), expected)

  test([1..10], ((x) -> x is    0     ), [])
  test([1..10], ((x) -> x is    1     ), [1])
  test([1..10], ((x) -> x is    3     ), [3])
  test([1..10], ((x) -> x is   10     ), [10])
  test([1..10], ((x) -> x is   11     ), [])
  test([1..10], ((x) -> x  <    0     ), [])
  test([1..10], ((x) -> x  < 9001     ), [1..10])
  test([1..10], ((x) -> x %%    2 is 0), [2, 4, 6, 8, 10])
  test([1..10], ((x) -> x %%    6 is 0), [6])
  test([1..10], ((x) -> x %%   15 is 0), [])

  test([false, false, false], ((x) -> not x),  [false, false, false])
  test([false, false, false], ((x) -> x),      [])
  test([true,  true,  true ], ((x) -> not x),  [])
  test([true,  false, false], ((x) -> x),      [true])
  test([true,  false, false], ((x) -> not x),  [false, false])
  test([true,  false, false], ((x) -> not x?), [])

  test(["merpy", "gurpy"], ((x) -> x.length is 5), ["merpy", "gurpy"])
  test(["merpy", "gurpy"], ((x) -> x.length > 10), [])
  test(["merpy", "gurpy"], ((x) -> x[0] is "m"),   ["merpy"])
  test(["merpy", "gurpy"], ((x) -> x[0] is "g"),   ["gurpy"])
  test(["merpy", "gurpy"], ((x) -> x[0] is "x"),   [])

  test([], (-> true),  [])
  test([], (-> false), [])
  test([], exploder,   [])

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> x?),                      [[13..19], { apples: 3 }, false, 22, "dreq", [1..3]])
  test(megalist, ((x) -> not x?),                  [null])
  test(megalist, ((x) -> x is undefined),          [])
  test(megalist, ((x) -> x is true),               [])
  test(megalist, ((x) -> x is false),              [false])
  test(megalist, ((x) -> (x ? {})[1] is 2),        [[1..3]])
  test(megalist, ((x) -> (x ? {}).length > 10),    [])
  test(megalist, ((x) -> (x ? {}).length is 4),    ["dreq"])
  test(megalist, ((x) -> (x ? {}).length > 4),     [[13..19]])
  test(megalist, ((x) -> (x ? {}).apples?),        [{ apples: 3 }])
  test(megalist, ((x) -> (x ? {}).apples is 4),    [])
  test(megalist, ((x) -> x is "dreq"),             ["dreq"])
  test(megalist, ((x) -> x is "grek"),             [])
  test(megalist, ((x) -> x > 10 < 30),             [22])
  test(megalist, ((x) -> typeof(x) isnt 'object'), [false, 22, "dreq"])

)

QUnit.test("Array: find", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(find(f)(xs), expected)

  test([1..10], ((x) -> x is    0     ), undefined)
  test([1..10], ((x) -> x is    1     ), 1)
  test([1..10], ((x) -> x is    3     ), 3)
  test([1..10], ((x) -> x is   10     ), 10)
  test([1..10], ((x) -> x is   11     ), undefined)
  test([1..10], ((x) -> x  <    0     ), undefined)
  test([1..10], ((x) -> x  < 9001     ), 1)
  test([1..10], ((x) -> x %%    2 is 0), 2)
  test([1..10], ((x) -> x %%    6 is 0), 6)
  test([1..10], ((x) -> x %%   15 is 0), undefined)

  test([false, false, false], ((x) -> not x),  false)
  test([false, false, false], ((x) -> x),      undefined)
  test([true,  true,  true ], ((x) -> not x),  undefined)
  test([true,  false, false], ((x) -> x),      true)
  test([true,  false, false], ((x) -> not x),  false)
  test([true,  false, false], ((x) -> not x?), undefined)

  test(["merpy", "gurpy"], ((x) -> x.length is 5), "merpy")
  test(["merpy", "gurpy"], ((x) -> x.length > 10), undefined)
  test(["merpy", "gurpy"], ((x) -> x[0] is "m"),   "merpy")
  test(["merpy", "gurpy"], ((x) -> x[0] is "g"),   "gurpy")
  test(["merpy", "gurpy"], ((x) -> x[0] is "x"),   undefined)

  test([], (-> true),  undefined)
  test([], (-> false), undefined)
  test([], exploder,   undefined)

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> x?),                      [13..19])
  test(megalist, ((x) -> not x?),                  null)
  test(megalist, ((x) -> x is undefined),          undefined)
  test(megalist, ((x) -> x is true),               undefined)
  test(megalist, ((x) -> x is false),              false)
  test(megalist, ((x) -> (x ? {})[1] is 2),        [1..3])
  test(megalist, ((x) -> (x ? {}).length > 10),    undefined)
  test(megalist, ((x) -> (x ? {}).length is 4),    "dreq")
  test(megalist, ((x) -> (x ? {}).length > 4),     [13..19])
  test(megalist, ((x) -> (x ? {}).apples?),        { apples: 3 })
  test(megalist, ((x) -> (x ? {}).apples is 4),    undefined)
  test(megalist, ((x) -> x is "dreq"),             "dreq")
  test(megalist, ((x) -> x is "grek"),             undefined)
  test(megalist, ((x) -> x > 10 < 30),             22)
  test(megalist, ((x) -> typeof(x) isnt 'object'), false)

)

QUnit.test("Array: findIndex", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(findIndex(f)(xs), expected)

  test([1..10], ((x) -> x is    0     ), undefined)
  test([1..10], ((x) -> x is    1     ), 0)
  test([1..10], ((x) -> x is    3     ), 2)
  test([1..10], ((x) -> x is   10     ), 9)
  test([1..10], ((x) -> x is   11     ), undefined)
  test([1..10], ((x) -> x  <    0     ), undefined)
  test([1..10], ((x) -> x  < 9001     ), 0)
  test([1..10], ((x) -> x %%    2 is 0), 1)
  test([1..10], ((x) -> x %%    6 is 0), 5)
  test([1..10], ((x) -> x %%   15 is 0), undefined)

  test([false, false, false], ((x) -> not x),  0)
  test([false, false, false], ((x) -> x),      undefined)
  test([true,  true,  true ], ((x) -> not x),  undefined)
  test([true,  false, false], ((x) -> x),      0)
  test([true,  false, false], ((x) -> not x),  1)
  test([true,  false, false], ((x) -> not x?), undefined)

  test(["merpy", "gurpy"], ((x) -> x.length is 5), 0)
  test(["merpy", "gurpy"], ((x) -> x.length > 10), undefined)
  test(["merpy", "gurpy"], ((x) -> x[0] is "m"),   0)
  test(["merpy", "gurpy"], ((x) -> x[0] is "g"),   1)
  test(["merpy", "gurpy"], ((x) -> x[0] is "x"),   undefined)

  test([], (-> true),  undefined)
  test([], (-> false), undefined)
  test([], exploder,   undefined)

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> x?),                      0)
  test(megalist, ((x) -> not x?),                  1)
  test(megalist, ((x) -> x is undefined),          undefined)
  test(megalist, ((x) -> x is true),               undefined)
  test(megalist, ((x) -> x is false),              3)
  test(megalist, ((x) -> (x ? {})[1] is 2),        6)
  test(megalist, ((x) -> (x ? {}).length > 10),    undefined)
  test(megalist, ((x) -> (x ? {}).length is 4),    5)
  test(megalist, ((x) -> (x ? {}).length > 4),     0)
  test(megalist, ((x) -> (x ? {}).apples?),        2)
  test(megalist, ((x) -> (x ? {}).apples is 4),    undefined)
  test(megalist, ((x) -> x is "dreq"),             5)
  test(megalist, ((x) -> x is "grek"),             undefined)
  test(megalist, ((x) -> x > 10 < 30),             4)
  test(megalist, ((x) -> typeof(x) isnt 'object'), 3)

)

QUnit.test("Array: flatMap", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(flatMap(f)(xs), expected)

  test([],                                     exploder,                                 [])
  test([0..1000],                              ((x) -> []),                              [])
  test([0..1000],                              ((x) -> if x %% 2 is 0 then [x] else []), (x for x in [0..1000] by 2))
  test([[0, 2, 4], [3, 6, 9], [4, 8, 12, 16]], ((x) -> x),                               [0, 2, 4, 3, 6, 9, 4, 8, 12, 16])

  test(["apples", "grapes", "oranges", "grapes", "bananas"], ((x) -> if x.length isnt 7 then [x] else []), ["apples", "grapes", "grapes"])

  # Monad law tests below

  point = (x) -> [x]
  f     = (x) -> point("#{x}!")
  g     = (x) -> point("#{x}?")
  h     = (x) -> point("#{x}~")

  str  = "apples"
  strs = ["apples", "grapes", "oranges"]

  # Kleisli Arrow / Kleisli composition operator
  kleisli =
    (f1) -> (f2) -> (x) ->
      flatMap(f2)(f1(x))

  fgh1 = kleisli(kleisli(f)(g))(h)
  fgh2 = kleisli(f)(kleisli(g)(h))

  test(point(str), f,     f(str))                            # Left identity
  test(strs,       point, strs)                              # Right identity
  assert.deepEqual(flatMap(fgh1)(strs), flatMap(fgh2)(strs)) # Associativity

)

QUnit.test("Array: flattenDeep", (assert) ->

  test =
    (xs, expected) ->
      assert.deepEqual(flattenDeep(xs), expected)

  test([],                                                                                 [])
  test([[]],                                                                               [])
  test([[42]],                                                                             [42])
  test([[42], [], [[]]],                                                                   [42])
  test([[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]],                         [13, 14, 15, 16, 17, 18, 19, null, { apples: 3 }, false, 22, "dreq", 1, 2, 3])
  test([[13..19], [null], [[[], [{ apples: 3 }], false], [], 22], ["dreq", [1..3]], [[]]], [13, 14, 15, 16, 17, 18, 19, null, { apples: 3 }, false, 22, "dreq", 1, 2, 3])

)

QUnit.test("Array: foldl", (assert) ->

  test =
    (xs, x, f, expected) ->
      assert.deepEqual(foldl(f)(x)(xs), expected)

  # Non-functions
  test([], 9001, exploder, 9001)

  # Unprincipled functions
  test([],        0,  ((acc, x) -> x),                   0)         # No-op
  test([1..1000], 0,  ((acc, x) -> x),                   1000)      # Grab last
  test([1..1000], [], ((acc, x) -> acc.concat([x])),     [1..1000]) # Constructor replacement
  test([1..1000], [], ((acc, x) -> acc.concat([x + 1])), [2..1001]) # Map +1

  # Associative functions
  str = "I want chicken I want liver Meow Mix Meow Mix please deliver"
  test(str.split(" "), "", ((acc, x) -> "#{acc} #{x}"), " #{str}") # String concatenation

  # Commutative functions from here on out

  test([1..10], 9001, ((acc, x) -> acc + x), 9056) # Sum
  test([1..10], 0,    ((acc, x) -> acc * x), 0)    # Product

  arr = ["apples", "oranges", "grapes", "bananas"]
  test(arr, 0, ((acc, x) -> acc + x.length), arr.join("").length) # Length of string sum is sum of string lengths

  objs = [{ a: 4 }, { a: 10 }, { b: 32 }, { a: 2 }]
  test(objs, 1, ((acc, { a = 1 }) -> acc * a), 4 * 10 * 2) # Product of object properties

  trues  = [true, true, true, true, true, true, true, true, true]
  falses = [false, false, false, false, false]
  mixed  = [true, false, false, true, true]

  # All?
  andF = (x, y) -> x and y
  test(trues,  true,  andF, true)
  test(trues,  false, andF, false)
  test(falses, true,  andF, false)
  test(falses, false, andF, false)
  test(mixed,  true,  andF, false)
  test(mixed,  false, andF, false)

  # Any?
  orF = (x, y) -> x or y
  test(trues,  true,  orF, true)
  test(trues,  false, orF, true)
  test(falses, true,  orF, true)
  test(falses, false, orF, false)
  test(mixed,  true,  orF, true)
  test(mixed,  false, orF, true)

  x2     = (x) -> x * 2
  x5     = (x) -> x * 5
  x10    = (x) -> x * 10
  bigBoy = (x) -> x2(x5(x10(x)))

  compose = (f, g) -> (x) -> g(f(x)) # Monoidal binary operator
  id      = (x) -> x                 # Monoidal identity element

  # Function composition: Read it and weep
  assert.deepEqual(foldl(compose)(id)([x2, x5, x10])(9), bigBoy(9))

)

QUnit.test("Array: forEach", (assert) ->

  acc = ""

  test =
    (input, expected) ->
      forEach((x) -> acc += x)(input)
      assert.deepEqual(input.reduce(((x, y) -> x + y), ""), acc)
      acc = ""

  test([], "")
  test(["1"], "1")
  test(["1", "2"], "12")
  test(["0", "0", "0", "00", "0"], "000000")
  test(["13", "14", "15", "16", "17", "18", "19"], "13141516171819")

)

QUnit.test("Array: head", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(head(input), expected)

  test([],                   undefined)
  test([1],                  1)
  test([1..2],               1)
  test([13..19],             13)
  test([true, false, true],  true)
  test([false, false, true], false)
  test(["apples"],           "apples")
  test([{}, true, 10],       {})

)

QUnit.test("Array: headAndTail", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(headAndTail(input), expected)

  test([],                   [undefined, []])
  test([1],                  [1, []])
  test([1..2],               [1, [2]])
  test([13..19],             [13, [14..19]])
  test([true, false, true],  [true, [false, true]])
  test([false, false, true], [false, [false, true]])
  test(["apples"],           ["apples", []])
  test([{}, true, 10],       [{}, [true, 10]])

)

QUnit.test("Array: isEmpty", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(isEmpty(input), expected)

  test([],                   true)
  test([undefined],          false)
  test([null],               false)
  test([1],                  false)
  test([1..2],               false)
  test([13..19],             false)
  test([true, false, true],  false)
  test(["apples"],           false)
  test([{}, true, 10],       false)

)

QUnit.test("Array: item", (assert) ->

  test =
    (i, xs, expected) ->
      assert.deepEqual(item(i)(xs), expected)

  test(0,      [],                 undefined)
  test(-1,     [1],                undefined)
  test(0,      [1],                1)
  test(1,      [1],                undefined)
  test(9001,   [1],                undefined)
  test(0,      [13..19],           13)
  test(1,      [13..19],           14)
  test(2,      [13..19],           15)
  test(3,      [13..19],           16)
  test(4,      [13..19],           17)
  test(5,      [13..19],           18)
  test(6,      [13..19],           19)
  test(7,      [13..19],           undefined)
  test(1,      ["merpy", "gurpy"], "gurpy")
  test(0,      ["merpy", "gurpy"], "merpy")

)

QUnit.test("Array: last", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(last(input), expected)

  test([],                   undefined)
  test([1],                  1)
  test([1..2],               2)
  test([13..19],             19)
  test([true, false, true],  true)
  test([false, false, true], true)
  test(["apples"],           "apples")
  test([{}, true, 10],       10)

)

QUnit.test("Array: length", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(length(input), expected)

  test([],                   0)
  test([1],                  1)
  test([1..2],               2)
  test([13..19],             7)
  test([true, false, true],  3)
  test(["apples"],           1)
  test([{}, true, 10],       3)

)

QUnit.test("Array: map", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(map(f)(xs), expected)

  test([1..10], ((x) -> x + 1), [2..11])
  test([1..10], ((x) -> x * 2), (x for x in [2..20] by 2))

  test([true, false, false], ((x) -> x), [true, false, false])

  test(["oranges", "merpy", "gurpy!"], ((x) -> x.length), [7, 5, 6])
  test(["oranges", "merpy", "gurpy!"], ((x) -> x[0]),     ["o", "m", "g"])

  test([], (-> 9001), [])
  test([], exploder,  [])

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> x?),                      [ true, false,  true,  true,  true,  true,  true])
  test(megalist, ((x) -> not x?),                  [false,  true, false, false, false, false, false])
  test(megalist, ((x) -> x is undefined),          [false, false, false, false, false, false, false])
  test(megalist, ((x) -> x is false),              [false, false, false, true,  false, false, false])
  test(megalist, ((x) -> (x ? {}).length > 3),     [ true, false, false, false, false,  true, false])
  test(megalist, ((x) -> typeof(x) is 'object'),   [ true,  true,  true, false, false, false,  true])

  # Functor laws!

  f    = (x) -> "#{x}!"
  g    = (x) -> "#{x}?"
  id   = (x) -> x
  strs = ["apples", "grapes", "oranges", "bananas"]

  mapTwice    = pipeline(map(f), map(g))
  mapComposed = map(pipeline(f, g))

  test(strs, id, strs)                                # Identity
  assert.deepEqual(mapTwice(strs), mapComposed(strs)) # Associativity

)

QUnit.test("Array: maxBy", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(maxBy(f)(xs), expected)

  test([1..10],       ((x) ->  x), 10)
  test([1..10],       ((x) -> -x), 1)
  test([1..10],       ((x) ->  0), 1)
  test([4, 2, 6, 10], ((x) ->  0), 4)

  test([false, false, false], ((x) -> if x then 1 else 0), false)
  test([true,   true,  true], ((x) -> if x then 1 else 0), true)
  test([true,  false, false], ((x) -> if x then 1 else 0), true)
  test([true,  false, false], ((x) -> if x then 0 else 1), false)

  test(["apples", "grapes", "oranges", "bananas"], ((x) -> x.length),                    "oranges")
  test(["apples", "grapes", "oranges", "bananas"], ((x) -> (x.match(/a/g) ? []).length), "bananas")

  test([], (-> 0),   undefined)
  test([], exploder, undefined)

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> (x ? {}).apples ? 0),                       { apples: 3 })
  test(megalist, ((x) -> (x ? {}).length ? 0),                       [13..19])
  test(megalist, ((x) -> if isNaN(Number(x)) then 0 else Number(x)), 22)

)

QUnit.test("Array: sortBy", (assert) ->

  test =
    (xs, f, expected) ->
      assert.deepEqual(sortBy(f)(xs), expected)

  test([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0],       ((x) -> x),           [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  test([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],       ((x) -> x),           [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  test([1, 2, 3, 0, 4, 5, 6, 7, 8, 9, 10],       ((x) -> x),           [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  test([1, 2, 3, 0, 4, 5, 6, 7, 8, 0, 9, 10, 0], ((x) -> x),           [0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  test([6, 24, 4, 78, 22, 4, 4, 13, 22, 0],      ((x) -> x),           [0, 4, 4, 4, 6, 13, 22, 22, 24, 78])
  test([-6, 24, 4, -78, 22, -4, 4, 13, 22, -0],  ((x) -> x),           [-78, -6, -4, -0, 4, 4, 13, 22, 22, 24])
  test([-6, 24, 4, -78, 22, -4, 4, 13, 22, -0],  ((x) -> Math.abs(x)), [-0, 4, -4, 4, -6, 13, 22, 22, 24, -78])

  test([false, false, false], ((x) -> if x then 1 else 0), [false, false, false])
  test([false, false, false], ((x) -> if x then 0 else 1), [false, false, false])
  test([true,  true,  true ], ((x) -> if x then 1 else 0), [true,  true,  true ])
  test([true,  true,  true ], ((x) -> if x then 0 else 1), [true,  true,  true ])
  test([true,  false, false], ((x) -> if x then 1 else 0), [false, false, true ])
  test([true,  false, false], ((x) -> if x then 0 else 1), [true,  false, false])

  test(["short",  "a long",  "a longer", "the longest"], ((x) -> x),        ["a long", "a longer", "short", "the longest"])
  test(["a long", "short",   "a longer", "the longest"], ((x) -> x.length), ["short", "a long", "a longer", "the longest"])

  test([],        (-> 0),   [])
  test([],        exploder, [])
  test([4, 2, 6], (-> 0),   [4, 2, 6])

  test([8],                (-> 0), [8])
  test([{}],               (-> 0), [{}])
  test([{ argon: 18 }],    (-> 0), [{ argon: 18 }])
  test([""],               (-> 0), [""])
  test(["apples"],         (-> 0), ["apples"])
  test([[]],               (-> 0), [[]])
  test([[true, false, 1]], (-> 0), [[true, false, 1]])
  test([true],             (-> 0), [true])
  test([false],            (-> 0), [false])

  megalist = [[13..19], null, { apples: 3 }, false, 22, "dreq", [1..3]]
  test(megalist, ((x) -> typeof(x)),                       [false, 22, [13..19], null, { apples: 3 }, [1..3], "dreq"])
  test(megalist, ((x) -> (x ? { apples: -1 }).apples ? 0), [null, [13..19], false, 22, "dreq", [1..3], { apples: 3 }])
  test(megalist, ((x) -> (x ? { length: 1 }).length ? 0),  [{ apples: 3 }, false, 22, null, [1..3], "dreq", [13..19]])

)

QUnit.test("Array: sortedIndexBy", (assert) ->

  test =
    (xs, x, f, expected) ->
      assert.deepEqual(sortedIndexBy(f)(xs)(x), expected)

  test([1..10], 0,    ((x) -> x), 0)
  test([1..10], 2,    ((x) -> x), 1)
  test([1..10], 2.1,  ((x) -> x), 2)
  test([1..10], 11,   ((x) -> x), 10)
  test([1..10], 9001, ((x) -> x), 10)

  test([false, false, false], false, ((x) -> if x then 1 else 0), 0)
  test([false, false, false], true,  ((x) -> if x then 1 else 0), 3)
  test([false, false, false], false, ((x) -> if x then 0 else 1), 0)
  test([false, false, false], true,  ((x) -> if x then 0 else 1), 0)
  test([true,  true,  true ], false, ((x) -> if x then 1 else 0), 0)
  test([true,  true,  true ], true,  ((x) -> if x then 1 else 0), 0)
  test([true,  true,  true ], false, ((x) -> if x then 0 else 1), 3)
  test([true,  true,  true ], true,  ((x) -> if x then 0 else 1), 0)
  test([true,  false, false], false, ((x) -> if x then 1 else 0), 0)
  test([true,  false, false], true,  ((x) -> if x then 1 else 0), 0)
  test([true,  false, false], false, ((x) -> if x then 0 else 1), 1)
  test([true,  false, false], true,  ((x) -> if x then 0 else 1), 0)

  test(["short", "a long", "a longer", "the longest"], "a longish",         ((x) -> x.length), 3)
  test(["short", "a long", "a longer", "the longest"], "123",               ((x) -> x.length), 0)
  test(["short", "a long", "a longer", "the longest"], "lorem ipsum dolor", ((x) -> x.length), 4)
  test(["short", "a long", "a longer", "the longest"], "a long",            ((x) -> x.length), 1)
  test(["short", "a long", "a longer", "the longest"], "a longé",           ((x) -> x.length), 2)

  test([],                8, (-> 9001), 0)
  test([],               {}, (-> 9001), 0)
  test([],    { argon: 18 }, (-> 9001), 0)
  test([],               "", (-> 9001), 0)
  test([],         "apples", (-> 9001), 0)
  test([],               [], (-> 9001), 0)
  test([], [true, false, 1], (-> 9001), 0)
  test([],             true, (-> 9001), 0)
  test([],            false, (-> 9001), 0)

  megalist = [false, 22, [13..19], null, { apples: 3 }, [1..3], "dreq"]
  test(megalist, true,      ((x) -> typeof(x)), 0)
  test(megalist, 23,        ((x) -> typeof(x)), 1)
  test(megalist, [2..4],    ((x) -> typeof(x)), 2)
  test(megalist, null,      ((x) -> typeof(x)), 2)
  test(megalist, {},        ((x) -> typeof(x)), 2)
  test(megalist, "",        ((x) -> typeof(x)), 6)
  test(megalist, "bobby",   ((x) -> typeof(x)), 6)
  test(megalist, undefined, ((x) -> typeof(x)), 7)

)

QUnit.test("Array: tail", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(tail(input), expected)

  test([],       [])
  test([1],      [])
  test([1..2],   [2])
  test([13..19], [14..19])

)

QUnit.test("Array: toObject", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(toObject(input), expected)

  test([],           {})
  test([["a", "b"]], { a: "b" })
  test([[1, 2]],     { 1: 2 })
  test([[1, 2], ["a", "b"], ["blue", 42], ["redIsGreen", false]], { 1: 2, a: "b", blue: 42, redIsGreen: false })

)

QUnit.test("Array: unique", (assert) ->

  test =
    (input, expected) ->
      assert.deepEqual(unique(input), expected)

  test([],     [])
  test([1],    [1])
  test([1, 1], [1])
  test([1, 7, 4, 2, 7, 1, 3], [1, 7, 4, 2, 3])

  test([""],       [""])
  test(["A"],      ["A"])
  test(["A", "A"], ["A"])
  test(["A", "B", "A", "F", "D", "B", "C"], ["A", "B", "F", "D", "C"])

  test([true,  true],  [true])
  test([false, false], [false])
  test([true,  false], [true, false])
  test([false, true, true], [false, true])

  test([    []],  [[]])
  test([   [1]], [[1]])
  test([[], []],  [[]])

  apples = { a: 10, sargus: "mcmargus" }
  test([{}], [{}])
  test([apples], [apples])
  test([apples, {}], [apples, {}])
  test([apples, apples, {}], [apples, {}])
  test([apples, apples, {}], [apples, {}])
  test([apples, {}, apples, {}, {}], [apples, {}])

)

QUnit.test("Array: uniqueBy", (assert) ->

  testEq =
    (input, expected) ->
      assert.deepEqual(uniqueBy(id)(input), expected)

  apples = { a: 10, sargus: "mcmargus" }

  testEq([],     [])
  testEq([1],    [1])
  testEq([1, 1], [1])
  testEq([1, 7, 4, 2, 7, 1, 3], [1, 7, 4, 2, 3])

  testEq([""],       [""])
  testEq(["A"],      ["A"])
  testEq(["A", "A"], ["A"])
  testEq(["A", "B", "A", "F", "D", "B", "C"], ["A", "B", "F", "D", "C"])

  testEq([true,  true],  [true])
  testEq([false, false], [false])
  testEq([true,  false], [true, false])
  testEq([false, true, true], [false, true])

  testEq([[]],  [[]])
  testEq([[1]], [[1]])
  testEq([[], []], [[]])

  testEq([{}], [{}])
  testEq([apples], [apples])
  testEq([apples, {}], [apples, {}])
  testEq([apples, apples, {}], [apples, {}])
  testEq([apples, apples, {}], [apples, {}])
  testEq([apples, {}, apples, {}, {}], [apples, {}])

  testLength =
    (input, expected) ->
      assert.deepEqual(uniqueBy((x) -> x.length)(input), expected)

  testLength([],       [])
  testLength([[]],     [[]])
  testLength([[], []], [[]])
  testLength([[], [], [9001], [], [2], [1..4], [], [0]], [[], [9001], [1..4]])

)

QUnit.test("Array: zip", (assert) ->

  test =
    (xs, ys, expected) ->
      assert.deepEqual(zip(xs)(ys), expected)

  test([],                    [],       [])
  test([],                    [10..20], [])
  test(["apples"],            [],       [])
  test(["apples"],            [10..20], [["apples", 10]])
  test(["apples", "oranges"], [10..20], [["apples", 10], ["oranges", 11]])
  test(["apples", "oranges"], [10],     [["apples", 10]])
  test([1..10],               [10..19], [[1, 10], [2, 11], [3, 12], [4, 13], [5, 14], [6, 15], [7, 16], [8, 17], [9, 18], [10, 19]])

)
