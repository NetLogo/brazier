{ arrayEquals, objectEquals          } = require('brazier/equals')
{ pipeline                           } = require('brazier/function')
{ None, Something                    } = require('brazier/maybe')
{ clone, keys, lookup, pairs, values } = require('brazier/object')

QUnit.test("Object: clone", (assert) ->
  test = (x) -> assert.deepEqual(clone(x), x)
  test({})
  test({ a: undefined })
  test({ a: 3 })
  test({ a: "abc", z: 123, d: [], b: false })
)

QUnit.test("Object: keys", (assert) ->
  test = (x, y) -> assert.deepEqual(keys(x), y)
  test({},                                    [])
  test({ a: undefined },                      ["a"])
  test({ a: 3 },                              ["a"])
  test({ a: "abc", z: 123, d: [], b: false }, ["a", "z", "d", "b"])
)

QUnit.test("Object: lookup", (assert) ->
  test = (key, obj, y) -> assert.deepEqual(lookup(key)(obj), y)
  test('anything', {},                                    None)
  test('a',        { a: undefined },                      Something(undefined))
  test('other',    { a: undefined },                      None)
  test('marvin',   { marvin: 3 },                         Something(3))
  test('a',        { a: "abc", z: 123, d: [], b: false }, Something("abc"))
  test('b',        { a: "abc", z: 123, d: [], b: false }, Something(false))
  test('z',        { a: "abc", z: 123, d: [], b: false }, Something(123))
  test('d',        { a: "abc", z: 123, d: [], b: false }, Something([]))
  test('g',        { a: "abc", z: 123, d: [], b: false }, None)
)

QUnit.test("Object: pairs", (assert) ->
  test = (x, y) -> assert.deepEqual(pairs(x), y)
  test({},                                    [])
  test({ a: undefined },                      [["a", undefined]])
  test({ a: 3 },                              [["a", 3]])
  test({ a: "abc", z: 123, d: [], b: false }, [["a", "abc"], ["z", 123], ["d", []], ["b", false]])
)

QUnit.test("Object: values", (assert) ->
  test = (x, y) -> assert.deepEqual(values(x), y)
  test({},                                    [])
  test({ a: undefined },                      [undefined])
  test({ a: 3 },                              [3])
  test({ a: "abc", z: 123, d: [], b: false }, ["abc", 123, [], false])
)
