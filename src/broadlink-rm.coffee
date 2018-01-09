# Description
#    Learns and sends IR hex codes with Broadlink RM.
#
# Configuration:
#   None
#
# Commands:
#   hubot learn <code> [n-m] [@<room>]    - Learns IR hex code at <room> and names it <code>.
#   hubot send <code>[@<room>] ...    - Sends IR hex <code> to <room>.
#   hubot list    - Shows all codes and rooms.
#   hubot delete <code>    - Deletes IR hex <code>.
#   hubot delete @<room>    - Deletes <room>.
#   hubot get <code>    - Shows IR hex code of <code>.
#   hubot get @<room>    - Shows MAC or IP address of <room>.
#   hubot set <code> <hex>    - Names <hex> <code>.
#   hubot set @<room> [<MAC>|<IP>]    - Names MAC or IP address <room>.
#   hubot help    - Shows usage.
#   where
#       <code> ::= [0-9a-z:]+
#       <room> ::= [0-9a-z:]+
#       <MAC>  ::= [0-9a-f:]+
#       <IP>   ::= [0-9.]+
#
# Examples:
#   hubot learn light:on                    - Learns IR hex code and names it light:on.
#   hubot send light:on                     - Sends IR hex code of light:on.
#   hubot send tv:off aircon:off light:off  - Sends three codes in turn.
#   hubot learn tv:ch 1-8                   - Learns eight codes tv:ch1, tv:ch2, ..., tv:ch8 in turn.
#   hubot leran aircon:warm 14-30           - Also useful to learn many codes of air conditioner.
#   hubot get aircon:warm22                 - Shows IR hex code of aircon:warm22.
#   hubot set aircon:clean 123abc...        - Names IR hex code of aircon:clean 123abc... .
#   hubot set @kitchen 192.168.1.23         - Names IP address 192.168.1.23 kitchen.
#   hubot set @bedroom xx:xx:xx:xx:xx       - Names MAC address xx:xx:xx:xx:xx bedroom.
#   hubot learn light:off @kitchen          - Learns IR hex code of light:on at kitchen.
#   hubot send light:off@kitchen            - Sends IR hex code of light:on at kitchen.
#   hubot send light:off@kitchen light:on@bedroom - Sends light:off at kitchen and light:on at bedroom.
#   hubot delete aircon:clean               - Deletes the code of aircon:clean.
#   hubot list                              - Shows all names of codes and rooms.
#   hubot help                              - Shows usage.
#
# Notes:
#   Tested with Broadlink RM Mini3.
#
# Author:
#   tak <tak.jaga@gmail.com>

'use strict'

module.exports = (robot) ->
    robot.respond ///(send(\s+#{CODE}(#{AT})?)+)$///i,               (res) -> sendN  robot, res
    robot.respond ///learn\s+(#{CODE})\s*(#{AT})?$///i,              (res) -> learn1 robot, res
    robot.respond ///learn\s+(#{CODE})\s+#{RANGE}(\s+(#{AT}))?$///i, (res) -> learnN robot, res
    robot.respond ///get\s+(@?#{NAME})$///i,                         (res) -> get    robot, res
    robot.respond ///set\s+(@?#{NAME})\s+(#{HEX_ADDR})$///i,         (res) -> set    robot, res
    robot.respond ///delete\s+(@?#{NAME})$///i,                      (res) -> delet  robot, res
    robot.respond ///list$///i,                                      (res) -> list   robot, res

NAME     = '[0-9a-z:]+'
CODE     = NAME
AT       = '@' + NAME
RANGE    = '(\\d+)-(\\d+)'
HEX_ADDR = '[0-9a-f:.]+'

getDevice = require 'homebridge-broadlink-rm/helpers/getDevice'
learnData = require 'homebridge-broadlink-rm/helpers/learnData'

# Commands

sendN = (robot, res) ->
    keys = res.match[1].toLowerCase().split /\s+/
    keys.shift()
    sendN_ robot, res, keys

sendN_ = (robot, res, keys) ->
    repeat keys, (key, callback) ->
        send robot, res, key, callback

send = (robot, res, key_room, callback) ->
    { key, room } = parse key_room
    code = getVal robot, key
    host = getVal robot, room
    back = (msg) -> res.send msg ; callback()
    if code
        device = getDevice { host }
        if device
            buffer = new Buffer code, 'hex'
            device.sendData buffer
            setTimeout (-> back "sent #{key}"), 1000
        else
            back "device not found #{host}"
    else
        back "no such code #{key}"

parse = (key) ->
    m = key.match /([^@]+)(@.+)?/
    { key: m[1], room: m[2] }

repeat = (a, f) ->
    if a.length > 0
        f a[0], ->
            a.shift()
            repeat a, f

learn1 = (robot, res) ->
    key  = res.match[1] .toLowerCase()
    room = res.match[2]?.toLowerCase()
    learn robot, res, key, room, (->)

learnN = (robot, res) ->
    key   = res.match[1] .toLowerCase()
    room  = res.match[5]?.toLowerCase()
    start = Number res.match[2]
    stop  = Number res.match[3]
    repeat [start .. stop], (n, callback) ->
        learn robot, res, key + n, room, callback

learn = (robot, res, key, room, callback) ->
    code = undefined
    host = getVal robot, room
    read = (str) ->
        m = str.match /Learn Code \(learned hex code: (\w+)\)/
        code = m[1] if m
    notFound = true
    prompt = ->
        notFound = false
        res.send "ready #{key}"
    setCd = ->
        setVal robot, key, code
        learnData.stop (->)
        respond res, key, code
        callback()
    learnData.start host, prompt, setCd, read, false
    if notFound
        res.send "device not found #{host}"

respond = (res, key, code) ->
    if code
        res.send "set #{key} to #{code}"
    else
        res.send "#{key} failed to learn code"

get = (robot, res) ->
    key = res.match[1].toLowerCase()
    val = getVal robot, key
    res.send "#{key} = #{val}"

set = (robot, res) ->
    key  = res.match[1].toLowerCase()
    code = res.match[2].toLowerCase()
    setVal robot, key, code
    respond res, key, code

delet = (robot, res) ->
    key = res.match[1].toLowerCase()
    deleteVal robot, key
    res.send "deleted #{key}"

list = (robot, res) ->
    keys = getKeys robot
    res.send keys.sort().join '\n'

# Persistence

getVal = (robot, key) ->
    robot.brain.get key

setVal = (robot, key, code) ->
    robot.brain.set key, code
    addKey robot, key

deleteVal = (robot, key) ->
    robot.brain.remove key
    deleteKey robot, key

addKey = (robot, key) ->
    keySet = getKeySet robot
    keySet.add key
    setKeySet robot, keySet

deleteKey = (robot, key) ->
    keySet = getKeySet robot
    keySet.delete key
    setKeySet robot, keySet

getKeys = (robot) ->
    str = robot.brain.get '_keys_'
    if str then JSON.parse str else []

getKeySet = (robot) ->
    new Set(getKeys robot)

setKeySet = (robot, keySet) ->
    str = JSON.stringify(Array.from keySet)
    robot.brain.set '_keys_', str
