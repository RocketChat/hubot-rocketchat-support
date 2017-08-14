# Description
#   Support helper script for the official Rocket.Chat #support channel
#
# Commands:
#   SupportBot
#   SupportBot logging
#   SupportBot ssl frdmn
#
# Author:
#   Jonas Friedmann <j@frd.mn>

pickRandom = require('pick-key');

topics =
  client:
    """Use this link to download the mobile (Android and iOS) and desktop (Linux, macOS and Windows) clients: https://rocket.chat/download"""
  codeblocks:
    """To format/highlight code blocks you can use Markdown syntax like this: http://i.imgur.com/gjSrpht.png"""
  deploy:
    """Which deployment method do you use to run Rocket.Chat? Manual installation, Docker or any other cloud service?"""
  docs:
    """You can find lots of additional information, tutorials and documentation on our docs page: https://rocket.chat/docs"""
  logging:
    """Please raise the log level in your administration UI ( _Admin_ → _Logs_ ) for more detailed error/warning messages:
    - "Loglevel" `2 - error, info and debug`
    - "show packet" `true`
    - "show file and number" `true`"""
  ssl:
    """Please inspect your SSL/TLS web server configuration using https://www.ssllabs.com/ssltest/ — Usually there is an issue with the intermediate certificate chain (incomplete) which often results in client side errors."""

module.exports = (robot) ->
  robot.respond /([a-zA-Z-]+)? ?([a-zA-Z0-9\.@_-]+)?/i, (msg) ->
    topic = msg.match[1]
    target = msg.match[2]

    if !topic || !topics[topic]
      msg.send "Available support topics: `" + Object.keys(topics).join('`, `') + "`. For example:\n" +
      """```
      @#{msg.robot.name} #{pickRandom(topics)}
      @#{msg.robot.name} #{pickRandom(topics)} @#{msg.message.user.name}
      ```"""
      return

    if topic && topics[topic]
      answer = topics[topic]

    if target
      answer = "@" + target.replace('@', '') + " " + answer

    msg.send answer
