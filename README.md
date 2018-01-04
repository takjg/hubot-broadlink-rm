# hubot-broadlink-rm

A hubot script to learn and send IR hex codes with Broadlink RM

See [an example](https://scrapbox.io/smart-home) how to use the script with Slack, IFTTT, Google Home, and Amazon Echo.

See [`src/broadlink-rm.coffee`](src/broadlink-rm.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-broadlink-rm --save`

Then add **hubot-broadlink-rm** to your `external-scripts.json`:

```json
[
  "hubot-broadlink-rm"
]
```

## Sample Interaction

```
user>> hubot learn light:on                    - Learns IR hex code and names it light:on.
user>> hubot send light:on                     - Sends IR hex code of light:on.
user>> hubot send tv:off aircon:off light:off  - Sends three codes in turn.
user>> hubot learn tv:ch 1-8                   - Learns eight codes tv:ch1, tv:ch2, ..., tv:ch8 in turn.
user>> hubot leran aircon:warm 14-30           - Is also useful to learn many codes of air conditioner.
user>> hubot get aircon:warm22                 - Shows IR hex code of aircon:warm22.
user>> hubot set aircon:clean 123abc...        - Names IR hex code of aircon:clean 123abc... .
user>> hubot set @kitchen 192.168.1.23         - Names IP address 192.168.1.23 kitchen.
user>> hubot set @bedroom xx:xx:xx:xx:xx       - Names MAC address xx:xx:xx:xx:xx bedroom.
user>> hubot learn light:off @kitchen          - Learns IR hex code of light:on at kitchen.
user>> hubot send light:off@kitchen            - Sends IR hex code of light:on at kitchen.
user>> hubot send light:off@kitchen light:on@bedroom - Sends light:off at kitchen and light:on at bedroom.
user>> hubot delete aircon:clean               - Deletes the code of aircon:clean.
user>> hubot list                              - Shows all names of codes and rooms.
user>> hubot help                              - Shows usage.
```

## NPM Module

https://www.npmjs.com/package/hubot-broadlink-rm
