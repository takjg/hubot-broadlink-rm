# Description
#    Learns and sends IR hex codes with Broadlink RM.
#
# Configuration:
#   None
#
# Commands:
#   hubot learn <name> [n-m]  - Learns IR hex code and names it <name>.
#   hubot send <name> ...     - Sends IR hex code of <name>.
#   hubot list                - Shows all names of codes.
#   hubot delete <name>       - Deletes code of <name>.
#   hubot get <name>          - Shows IR hex code of <name>.
#
# Examples:
#   hubot learn light:on                    - Learns IR hex code and names it light:on.
#   hubot send light:on                     - Sends IR hex code of light:on.
#   hubot send tv:off aircon:off light:off  - Sends three codes in turn.
#   hubot learn tv:ch 1-8                   - Learns eight codes tv:ch1, tv:ch2, ..., tv:ch8 in turn.
#   hubot leran aircon:warm 14-30           - Is also useful to learn many codes of air conditioner.
#   hubot get aircon:warm22                 - Shows IR hex code of aircon:warm22.
#
# Notes:
#   Tested with Broadlink RM Mini3.
#
# Author:
#   tak <tak.jaga@gmail.com>

module.exports = (robot) ->
    robot.respond  /(send(\s+[a-z0-9:]+)+)$/i,             (res) -> sendN  robot, res
    robot.respond  /learn\s+([a-z0-9:]+)$/i,               (res) -> learn1 robot, res
    robot.respond  /learn\s+([a-z0-9:]+)\s+(\d+)-(\d+)$/i, (res) -> learnN robot, res
    robot.respond    /get\s+([a-z0-9:]+)$/i,               (res) -> get    robot, res
    robot.respond /delete\s+([a-z0-9:]+)$/i,               (res) -> delet  robot, res
    robot.respond /list$/i,                                (res) -> list   robot, res

getDevice = require 'homebridge-broadlink-rm/helpers/getDevice'
learnData = require 'homebridge-broadlink-rm/helpers/learnData'

# Commands

host = undefined  # mac or ip

sendN = (robot, res) ->
    keys = res.match[1].toLowerCase().split(/\s+/)
    keys.shift()
    sendN_ robot, res, keys

sendN_ = (robot, res, keys) ->
    repeat keys, (key, callback) ->
        send robot, res, key, callback

send = (robot, res, key, callback) ->
    code = getCode robot, key
    back = (msg) -> res.send msg ; callback()
    if code
        device = getDevice { host }
        if device
            buffer = new Buffer(code, 'hex')
            device.sendData buffer
            setTimeout (-> back "sent code of #{key}"), 1000
        else
            back 'device not found'
    else
        back "no such code #{key}"

repeat = (a, f) ->
    if a.length > 0
        f a[0], ->
            a.shift()
            repeat a, f

learn1 = (robot, res) ->
    key = res.match[1].toLowerCase()
    learn robot, res, key, (->)

learnN = (robot, res) ->
    key   = res.match[1].toLowerCase()
    start = Number res.match[2]
    stop  = Number res.match[3]
    repeat [start .. stop], (n, callback) ->
        learn robot, res, key + n, callback

learn = (robot, res, key, callback) ->
    code = undefined
    read = (str) ->
        m = str.match /Learn Code \(learned hex code: (\w+)\)/
        code = m[1] if m
    prompt = ->
        res.send "#{key} ready"
    setCd = ->
        setCode robot, key, code
        learnData.stop (->)
        resLearned res, key, code
        callback()
    learnData.start host, prompt, setCd, read, false

resLearned = (res, key, code) ->
    if code
        res.send "#{key} learned #{code}"
    else
        res.send "#{key} failed to learn code"

get = (robot, res) ->
    key  = res.match[1].toLowerCase()
    code = getCode robot, key
    res.send "#{key} = #{code}"

delet = (robot, res) ->
    key = res.match[1].toLowerCase()
    deleteCode robot, key
    res.send "deleted code of #{key}"

list = (robot, res) ->
    keys = getKeys robot
    res.send keys.join('\n')

# Persistence

getCode = (robot, key) ->
    robot.brain.get key

setCode = (robot, key, code) ->
    robot.brain.set key, code
    addKey robot, key

deleteCode = (robot, key) ->
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
