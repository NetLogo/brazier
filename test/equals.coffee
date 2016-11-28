{ arrayEquals, booleanEquals, eq, numberEquals, objectEquals, stringEquals } = require('brazier/equals')

testArray =
  (equals) -> (assert) ->

    assert.ok(equals(     [])(     []) is true)
    assert.ok(equals(    [1])(    [1]) is true)
    assert.ok(equals([1..30])([1..30]) is true)
    assert.ok(equals([9001, 32, "apples", {}, [3, 32], false])([9001, 32, "apples", {}, [3, 32], false]) is true)

    assert.ok(not equals(     [])(    [1]) is true)
    assert.ok(not equals([1..31])([1..30]) is true)
    assert.ok(not equals([1..30])([1..31]) is true)

testBoolean =
  (equals) -> (assert) ->

    assert.ok(equals( true)( true) is true)
    assert.ok(equals(false)(false) is true)

    assert.ok(not equals( true)(false) is true)
    assert.ok(not equals(false)( true) is true)

testFunction =
  (equals) -> (assert) ->
    assert.ok(equals(  arrayEquals)(  arrayEquals) is true)
    assert.ok(equals(booleanEquals)(booleanEquals) is true)
    assert.ok(equals(           eq)(           eq) is true)
    assert.ok(equals( numberEquals)( numberEquals) is true)
    assert.ok(equals( objectEquals)( objectEquals) is true)
    assert.ok(equals( stringEquals)( stringEquals) is true)

testNumber =
  (equals) -> (assert) ->

    assert.ok(equals(       0)(       0) is true)
    assert.ok(equals(      -1)(      -1) is true)
    assert.ok(equals(    9001)(    9001) is true)
    assert.ok(equals(Infinity)(Infinity) is true)

    assert.ok(not equals(       0)(       -1) is true)
    assert.ok(not equals(      -1)(        0) is true)
    assert.ok(not equals(Infinity)(-Infinity) is true)

testObject =
  (equals) -> (assert) ->

    assert.ok(equals({})({}) is true)
    assert.ok(equals({ a: undefined })({ a: undefined }) is true)
    assert.ok(equals({ a: 3 })({ a: 3 }) is true)
    assert.ok(equals({ a: 3, b: {} })({ a: 3, b: {} }) is true)
    assert.ok(equals({ a: 3, b: [], d: { a: 4, b: "apples", z: false, g: "okay" } })({ a: 3, b: [], d: { a: 4, b: "apples", z: false, g: "okay" } }) is true)

    assert.ok(not equals(      {})({ a: 3 }) is true)
    assert.ok(not equals({ a: 3 })(      {}) is true)
    assert.ok(not equals(      {})({ a: undefined }) is true)

testString =
  (equals) -> (assert) ->

    assert.ok(equals(     "")(     "") is true)
    assert.ok(equals(    "1")(    "1") is true)
    assert.ok(equals("1..30")("1..30") is true)
    assert.ok(equals("9001, 32, 'apples', {}, [3, 32], false")("9001, 32, 'apples', {}, [3, 32], false") is true)

    assert.ok(not equals(     "")(    "1") is true)
    assert.ok(not equals("1..31")("1..30") is true)
    assert.ok(not equals("1..30")("1..31") is true)

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
