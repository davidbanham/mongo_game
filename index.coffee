mongoose = require 'mongoose'
async = require 'async'

mongoose.connect 'mongodb://localhost/guessing-game'

Thing = mongoose.model 'Thing', { name: String, stuff: Array }

Thing.schema.path('stuff').validate (stuff, cb) ->
  return cb false if stuff.indexOf('baz') > -1 and stuff.indexOf('bar') > -1
  cb true

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
      # For important business reasons we can never have a bar and a baz together
      if newStuff is 'bar' and thing.stuff.indexOf('baz') > -1
        fail = true
      if newStuff is 'baz' and thing.stuff.indexOf('bar') > -1
        fail = true
      if fail
        return console.log 'Sorry, valued client! You cannot have a bar with a baz. Please resubmit your request'
      thing.stuff.push newStuff
      thing.save cb
    , Math.random() * 1000

