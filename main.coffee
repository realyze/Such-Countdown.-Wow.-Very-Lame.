request = require 'superagent'
#lights = require './red'
oc = require 'onecolor'
Q = require 'q'
async = require 'async'
primality = require 'primality'

# Stupidly deep clone `obj`.
clone = (obj) -> JSON.parse JSON.stringify obj

originalLights = lights: ('#FF0000' for i in [0..49])

url = "http://192.168.23.254/iotas/0.1/device/moorescloud.holiday/localhost/setlights"

# Draws the colors on terminal. Stupid but works.
draw = (lights) ->
  for j in [0..6]
    if j % 2
      for i in [1..7].reverse()
        process.stdout.write(if (lights[i + j*7] == '#FF0000') then '0' else '1')
    else
      for i in [1..7]
        process.stdout.write(if (lights[i + j*7] == '#FF0000') then '0' else '1')
    process.stdout.write('\n')
  console.log('===============')


# Send the colors to holiday.
send = (lights) ->
  draw lights.lights
  defer = Q.defer()
  request
    .put(url)
    .send(lights)
    .end (res) ->
      console.log 'ok', res.statusCode
      defer.resolve()
  defer.promise


# generate random color
randomColor = ->
  oc('#FF0000').hue(Math.random(), true).hex()

{makePatternLeft, makePatternRight} = require './numberMap'
{numbers} = require './number'


# Draws a number on Holiday.
drawNumber = (number) ->
  left = Math.floor(number/10)
  right = number % 10

  lights = clone(originalLights)

  return send(lights: lights.lights)
    .then ->
      send(lights: makePatternLeft(lights.lights, numbers[left]))
    .then ->
      send(lights: makePatternRight(lights.lights, numbers[right]))
    .done()

explode = ->
  iterations = 10
  async.whilst ->
    iterations-- > 0
  ,  (fn) ->
    setTimeout ->
      lights = clone(originalLights)
      lights.lights = lights.lights.map (i) -> randomColor()
      send(lights)
      fn()
    , 500
  , ->
    console.log 'done!'

countdown = (iterations) ->
  async.whilst ->
    if primality(iterations)
      iterations -= 1
    console.log iterations
    iterations-- > 0
  ,  (fn) ->
    setTimeout ->
      drawNumber(iterations)
      fn()
    , 1000
  , ->
    setTimeout (-> explode()), 1000
    console.log 'done!'

countdown(20)
