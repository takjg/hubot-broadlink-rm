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
#
# Examples:
#   hubot learn light:on                    - Learns IR hex code and names it light:on.
#   hubot send light:on                     - Sends IR hex code of light:on.
#   hubot send tv:off aircon:off light:off  - Sends three codes in turn.
#   hubot learn tv:ch 1-8                   - Learns eight codes tv:ch1, tv:ch2, ..., tv:ch8 in turn.
#   hubot leran aircon:warm 14-30           - Is also useful to learn many codes of air conditioner.
#
# Notes:
#   Tested with Broadlink RM Mini3.
#
# Author:
#   tak <tak.jaga@gmail.com>

module.exports = (robot) ->
  robot.respond /hello/, (res) ->
    res.reply "hello!"

  robot.hear /orly/, (res) ->
    res.send "yarly"
