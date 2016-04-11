{ arrayEquals, objectEquals  } = require('brazier/equals')
{ pipeline                   } = require('brazier/function')
{ clone, keys, pairs, values } = require('brazier/object')

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
