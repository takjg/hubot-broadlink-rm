Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/broadlink-rm.coffee')

describe 'broadlink-rm', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()
