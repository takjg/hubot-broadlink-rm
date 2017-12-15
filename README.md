# hubot-broadlink-rm

A hubot script to learn and send IR hex codes with Broadlink RM

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
user1>> hubot learn light:on    - Learns IR hex code and names it light:on.
user1>> hubot send light:on    - Sends IR hex code of light:on.
user1>> hubot send tv:off aircon:off light:off    - Sends three codes in turn.
user1>> hubot learn tv:ch 1-8    - Learns eight codes tv:ch1, tv:ch2, ..., tv:ch8 in turn.
user1>> hubot leran aircon:warm 14-30    - Is also useful to learn many codes.
```

## NPM Module

https://www.npmjs.com/package/hubot-broadlink-rm
