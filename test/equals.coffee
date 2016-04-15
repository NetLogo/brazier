{ arrayEquals, booleanEquals, eq, numberEquals, objectEquals, stringEquals } = require('brazier/equals')

testArray =
  (equals) -> (assert) ->

    assert.ok(equals(     [])(     []))
    assert.ok(equals(    [1])(    [1]))
    assert.ok(equals([1..30])([1..30]))
    assert.ok(equals([9001, 32, "apples", {}, [3, 32], false])([9001, 32, "apples", {}, [3, 32], false]))

    assert.ok(not equals(     [])(    [1]))
    assert.ok(not equals([1..31])([1..30]))
    assert.ok(not equals([1..30])([1..31]))

testBoolean =
  (equals) -> (assert) ->

    assert.ok(equals( true)( true))
    assert.ok(equals(false)(false))

    assert.ok(not equals( true)(false))
    assert.ok(not equals(false)( true))

testFunction =
  (equals) -> (assert) ->
    assert.ok(equals(  arrayEquals)(  arrayEquals))
    assert.ok(equals(booleanEquals)(booleanEquals))
    assert.ok(equals(           eq)(           eq))
    assert.ok(equals( numberEquals)( numberEquals))
    assert.ok(equals( objectEquals)( objectEquals))
    assert.ok(equals( stringEquals)( stringEquals))

testNumber =
  (equals) -> (assert) ->

    assert.ok(equals(       0)(       0))
    assert.ok(equals(      -1)(      -1))
    assert.ok(equals(    9001)(    9001))
    assert.ok(equals(Infinity)(Infinity))

    assert.ok(not equals(       0)(       -1))
    assert.ok(not equals(      -1)(        0))
    assert.ok(not equals(Infinity)(-Infinity))

testObject =
  (equals) -> (assert) ->

    assert.ok(equals({})({}))
    assert.ok(equals({ a: undefined })({ a: undefined }))
    assert.ok(equals({ a: 3 })({ a: 3 }))
    assert.ok(equals({ a: 3, b: {} })({ a: 3, b: {} }))
    assert.ok(equals({ a: 3, b: [], d: { a: 4, b: "apples", z: false, g: "okay" } })({ a: 3, b: [], d: { a: 4, b: "apples", z: false, g: "okay" } }))

    assert.ok(not equals(      {})({ a: 3 }))
    assert.ok(not equals({ a: 3 })(      {}))
    assert.ok(not equals(      {})({ a: undefined }))

testString =
  (equals) -> (assert) ->

    assert.ok(equals(     "")(     ""))
    assert.ok(equals(    "1")(    "1"))
    assert.ok(equals("1..30")("1..30"))
    assert.ok(equals("9001, 32, 'apples', {}, [3, 32], false", "9001, 32, 'apples', {}, [3, 32], false"))

    assert.ok(not equals(     "")(    "1"))
    assert.ok(not equals("1..31")("1..30"))
    assert.ok(not equals("1..30")("1..31"))

QUnit.test("Equality: Any", (assert) ->
  testArray   (eq)(assert)
  testBoolean (eq)(assert)
  testFunction(eq)(assert)
  testNumber  (eq)(assert)
  testObject  (eq)(assert)
  testString  (eq)(assert)
)

QUnit.test("Equality: Array",    testArray   (  arrayEquals))
QUnit.test("Equality: Boolean",  testBoolean (booleanEquals))
QUnit.test("Equality: Function", testFunction(           eq))
QUnit.test("Equality: Number",   testNumber  ( numberEquals))
QUnit.test("Equality: Object",   testObject  ( objectEquals))
QUnit.test("Equality: String",   testString  ( stringEquals))
