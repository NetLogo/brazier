{ arrayEquals, booleanEquals, numberEquals, objectEquals, stringEquals } = require('brazier/equals')

QUnit.test("Equality: Array", (assert) ->

  assert.ok(arrayEquals(     [])(     []))
  assert.ok(arrayEquals(    [1])(    [1]))
  assert.ok(arrayEquals([1..30])([1..30]))
  assert.ok(arrayEquals([9001, 32, "apples", {}, [3, 32], false])([9001, 32, "apples", {}, [3, 32], false]))

  assert.ok(not arrayEquals(     [])(    [1]))
  assert.ok(not arrayEquals([1..31])([1..30]))
  assert.ok(not arrayEquals([1..30])([1..31]))

)

QUnit.test("Equality: Boolean", (assert) ->

  assert.ok(booleanEquals( true)( true))
  assert.ok(booleanEquals(false)(false))

  assert.ok(not booleanEquals( true)(false))
  assert.ok(not booleanEquals(false)( true))

)

QUnit.test("Equality: Number", (assert) ->

  assert.ok(numberEquals(       0)(       0))
  assert.ok(numberEquals(      -1)(      -1))
  assert.ok(numberEquals(    9001)(    9001))
  assert.ok(numberEquals(Infinity)(Infinity))

  assert.ok(not numberEquals(       0)(       -1))
  assert.ok(not numberEquals(      -1)(        0))
  assert.ok(not numberEquals(Infinity)(-Infinity))

)

QUnit.test("Equality: Object", (assert) ->

  assert.ok(objectEquals({})({}))
  assert.ok(objectEquals({ a: undefined })({ a: undefined }))
  assert.ok(objectEquals({ a: 3 })({ a: 3 }))
  assert.ok(objectEquals({ a: 3, b: {} })({ a: 3, b: {} }))
  assert.ok(objectEquals({ a: 3, b: [], d: { a: 4, b: "apples", z: false, g: "okay" } })({ a: 3, b: [], d: { a: 4, b: "apples", z: false, g: "okay" } }))

  assert.ok(not objectEquals(      {})({ a: 3 }))
  assert.ok(not objectEquals({ a: 3 })(      {}))
  assert.ok(not objectEquals(      {})({ a: undefined }))

)

QUnit.test("Equality: String", (assert) ->

  assert.ok(stringEquals(     "")(     ""))
  assert.ok(stringEquals(    "1")(    "1"))
  assert.ok(stringEquals("1..30")("1..30"))
  assert.ok(stringEquals("9001, 32, 'apples', {}, [3, 32], false", "9001, 32, 'apples', {}, [3, 32], false"))

  assert.ok(not stringEquals(     "")(    "1"))
  assert.ok(not stringEquals("1..31")("1..30"))
  assert.ok(not stringEquals("1..30")("1..31"))

)
