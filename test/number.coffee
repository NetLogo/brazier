{ multiply, plus, rangeTo, rangeUntil } = require('brazier/number')

QUnit.test("Number: multiply", (assert) ->
  assert.deepEqual(multiply(  0)(  5),    0)
  assert.deepEqual(multiply(  5)(  0),    0)
  assert.deepEqual(multiply(  5)(  6),   30)
  assert.deepEqual(multiply(  6)(  5),   30)
  assert.deepEqual(multiply(  1)(  1),    1)
  assert.deepEqual(multiply(  6)(  1),    6)
  assert.deepEqual(multiply(  1)(  6),    6)
  assert.deepEqual(multiply(  0)(  0),    0)
  assert.deepEqual(multiply(-10)(-15),  150)
  assert.deepEqual(multiply( 10)(-15), -150)
  assert.deepEqual(multiply( 15)(-10), -150)
)

QUnit.test("Function: plus", (assert) ->
  assert.deepEqual(plus(  0)(  5),   5)
  assert.deepEqual(plus(  5)(  0),   5)
  assert.deepEqual(plus(  5)(  6),  11)
  assert.deepEqual(plus(  6)(  5),  11)
  assert.deepEqual(plus(  1)(  1),   2)
  assert.deepEqual(plus(  0)(  0),   0)
  assert.deepEqual(plus(-10)(-15), -25)
  assert.deepEqual(plus( 10)(-15),  -5)
  assert.deepEqual(plus( 15)(-10),   5)
)

QUnit.test("Number: rangeTo", (assert) ->
  assert.deepEqual(rangeTo(0)( 5), [0, 1, 2, 3, 4, 5])
  assert.deepEqual(rangeTo(0)( 0), [0])
  assert.deepEqual(rangeTo(0)(-1), [])

)

QUnit.test("Number: rangeUntil", (assert) ->
  assert.deepEqual(rangeUntil(0)( 5), [0, 1, 2, 3, 4])
  assert.deepEqual(rangeUntil(0)( 0), [])
  assert.deepEqual(rangeUntil(0)(-1), [])
)
