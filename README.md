# hubot-rocketchat-support

A hubot script that does the things

See [`src/hubot-rocketchat-support.coffee`](src/hubot-rocketchat-support.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-rocketchat-support --save`

Then add **hubot-rocketchat-support** to your `external-scripts.json`:

```json
["hubot-rocketchat-support"]
```

## Sample Interaction

```
rcbot> rcbot support
rcbot> Available support topics: logging, deploy, ssl
rcbot> rcbot support logging
rcbot> Please raise the log level in your administartion UI (Admin -> Logs): `Loglevel: 2 - error, info and debug`, `show packet: true` and `show file and number: true`.
rcbot> rcbot support ssl frdmn
rcbot> @frdmn Please inspect your SSL/TLS web server configuration using https://www.ssllabs.com/ssltest/ Often the intermediate certificate chain is incomplete which often results in client side errors.
rcbot>
```
