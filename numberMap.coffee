mapLeft = [
 44, 43, 42
 39, 40, 41
 30, 29, 28
 25, 26, 27
 16, 15, 14
 11, 12, 13
 2, 1, 0
].map((i) -> i + 1).reverse()

mapRight = [
 49, 48, 47
 36, 37, 38
 35, 34, 33
 22, 23, 24
 21, 20, 19
 8, 9, 10
 7, 6, 5
].reverse()


makePattern = (part, lights, pattern) ->
  map = if part == 'left' then mapLeft else mapRight
  for i, index in pattern
    if i > 0
      lights[map[index]] = '#00FF00'
  return lights

exports.makePatternLeft = (lights, pattern) ->
  makePattern('left', lights, pattern)

exports.makePatternRight = (lights, pattern) ->
  makePattern('right', lights, pattern)
