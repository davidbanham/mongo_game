mongoose = require 'mongoose'
async = require 'async'

mongoose.connect 'mongodb://localhost/guessing-game'

Thing = mongoose.model 'Thing', { name: String, stuff: Array }

rando = ->
  return Math.floor(Math.random() * (1 << 24)).toString(16)

thang = new Thing {name: rando(), stuff: ['foo']}
thang.save (err) ->
  async.map ['bar', 'baz'], handleRequest, (err) ->
    Thing.findOne {name: thang.name}, (err, thing) ->
      console.log thing
      mongoose.disconnect()

handleRequest = (newStuff, cb) ->
  Thing.findOne {name: thang.name}, (err, thing) ->
    setTimeout ->
      # Let's add newStuff to the stuff. I sure hope this important data doesn't get lost because it's important.
      checkedStuff = thing.stuff.map (thingummy) ->
        # Do some important business in here.
        return thingummy
      checkedStuff.push newStuff
      thing.stuff = checkedStuff
      thing.save cb
    , Math.random() * 1000

