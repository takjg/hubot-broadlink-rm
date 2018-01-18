# hubot-broadlink-rm

A hubot script to learn and send IR hex codes with Broadlink RM

This allows you to control your RM Mini with Hubot, Slack, IFTTT, Google Home, and Amazon Echo.

![Overview](https://user-images.githubusercontent.com/34579033/34902770-89cb6c1a-f865-11e7-80e5-a9ed2f70515a.png)

#### No global IP is neeeded
When using with Slack, Hubot relays messages between Slack servers.
So it is not necessary to use tunneling services such as ngrok.

#### No programming is needed
You can control your RM Mini via Slack messages such as `learn light:on` and `send light:on`.

#### Easy to learn IR hex codes

Just use `learn` command.
```
user>> hubot learn light:on
ready light:on
set light:on to 2600ac00...
```
Several IR codes can be learned by one command.
```
user>> hubot learn tv:ch 1-8
ready tv:ch1
set tv:ch1 to ...
ready tv:ch2
set tv:ch2 to ...
:
ready tv:ch8
set tv:ch8 to ...
```

#### Detailed control

Several IR codes can be sent by one command.
```
user>> hubot tv:off ac:off light:off
sent tv:off
sent ac:off
sent light:off
```

Easy to schedule sending IR codes in detail.
```
user>> hubot [7h] ac:on
wait 7h
sent ac:on

user>> hubot tv:ch1 [3s] tv:source [2500ms] tv:source
sent tv:ch1
wait 3s
sent tv:source
wait 2500ms
tv:source
```

Easy to repeat sending IR codes.
```
user>> hubot tv:vol:up*4
sent tv:vol:up
sent tv:vol:up
sent tv:vol:up
sent tv:vol:up

user>> hubot tv:ch1 [3s] tv:source[2500ms]*2
sent tv:ch1
wait 3s
sent tv:source
wait 2500ms
sent tv:source
```

Easy to specify each RM Mini devices.
```
user>> hubot set @kitchen 01:23:45:67:89:ab
user>> hubot light:on@kitchen
```

#### UNIX commands can be used in `send`

You can control smart devices that do not have an IR reciever together with IR devices.
For example, you can name a UNIX command `curl -s https://SMART.DEVICE/API/on` `smart:device:on`.
```
user>> hubot command smart:device:on curl -s https://SMART.DEVICE/API/on
```

Then the smart device can be used in `send`.
```
user>> send smart:device:on() light:on tv:on
curl -s https://SMART.DEVICE/API/on
sent light:on
sent tv:on
```

A UNIX command can take an argument `#`.
The special character `#` is expanded when the command is called.
```
user>> hubot command say bin/google-home-notifier.sh "#"
user>> hubot send say(hello, world!)
bin/google-home-notifier.sh "hello  world "
said hellow  world
```
For security reasons, a text of the given argument is sanitized.
All Symbols of `hello, world!` (`,` and `!`) are replaced with a space.

## Documentation

For more details, see [a comprehensive guide](https://scrapbox.io/smart-home) to exploiting your RM Mini with Hubot, Slack, IFTTT, Google Home, and Amazon Echo.

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
user>> hubot leran aircon:warm 14-30           - Also Useful to learn many codes of air conditioner.
user>> hubot send [7h] aircon:warm24           - Will sends aircon:warm24 in seven hours.
user>> hubot send [7 hours] aircon:warm24
user>> hubot send [7時間] aircon:warm24
user>> hubot send tv:ch1 [2s] tv:source        - Sends tv:ch1 then sends tv:source in two seconds.
user>> hubot send tv:ch1 tv:source*3           - Sends tv:ch1 then sends tv:source three times
user>> hubot send tv:ch1 tv:source[2s]*3       - Sends tv:ch1 then sends tv:source three times in two seconds.
user>> hubot cancel                            - Cancels all unsent codes.
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

## Credits
Some parts of the code are from @lprhodes [Homebridge Broadlink RM]

His module for the communication is used.

Also the code is inspired by @jor3l [Broadlink RM server for IFTTT]

[Homebridge Broadlink RM]: https://github.com/lprhodes/homebridge-broadlink-rm
[Broadlink RM server for IFTTT]: https://github.com/jor3l/broadlinkrm-ifttt

## LICENSE

Copyright (c) 2017 Tak Jaga

Licensed under the [Apache License, Version 2.0][Apache]

[Apache]: http://www.apache.org/licenses/LICENSE-2.0
