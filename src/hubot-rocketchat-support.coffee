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

# Available support topics and responses
topics =
  codeblocks:
    """To format/highlight code blocks you can use Markdown syntax like this: http://i.imgur.com/gjSrpht.png"""
  deploy:
    """To pinpoint the problem you're having, which deployment method do you use to run Rocket.Chat? Manual installation, Docker or any other cloud service?"""
  docs:
    """You can find lots of additional information, tutorials and documentation on our docs page: https://rocket.chat/docs"""
  download:
    """Download the latest stable or beta *server* releases as well as the mobile ( _Android_ and _iOS_ ) and desktop ( _Linux_, _macOS_ and _Windows_ ) *clients* from https://rocket.chat/download. You can use `snap install rocketchat-server` for a _Snap_-based server installation - You can find additional deployment methods in our documentation: https://rocket.chat/docs/installation/paas-deployments"""
  logging:
    """Please raise the log level in your administration UI ( _Admin_ → _Logs_ ) for more detailed error/warning messages:
    - "Loglevel" `2 - error, info and debug`
    - "show packet" `true`
    - "show file and number" `true`
    Reproduce the problem and view the logs in the administartion UI ( _Admin_ → _View logs_ )"""
  ssl:
    """Please inspect your SSL/TLS web server configuration using https://www.ssllabs.com/ssltest/ — Usually there is an issue with the intermediate certificate chain (incomplete) which often results in client side errors."""
  themes:
    """Themes are not fully supported yet and are a [work in progress](https://github.com/RocketChat/Rocket.Chat/issues/277) — At the moment you would need to customize the `rocketchat-theme` / `rocketchat-ui` package or create your own to avoid conflicts on eventual updates. More information: https://rocket.chat/docs/developer-guides/ui-and-theming/themes/"""

# Cooldown to prevent spam for "hosting" keyword response
cooldownInMinutes = 3
cooldown = null

# Function to disable currently active cooldown
disableCooldown = ->
  cooldown = null
  return

module.exports = (robot) ->
  # Respond to support topics
  robot.respond /([a-zA-Z-]+)? ?([a-zA-Z0-9\.@_-]+)?/i, (msg) ->
    topic = msg.match[1]
    target = msg.match[2]

    # Check if topic is passed and if passed topic is defined in support topic object (above)
    if !topic || !topics[topic]
      msg.send "Available support topics: `" + Object.keys(topics).join('`, `') + "`. For example:\n" +
      """```@#{msg.robot.name} #{pickRandom(topics)}
      @#{msg.robot.name} #{pickRandom(topics)} @#{msg.message.user.name}
      ```"""
      return

    # If it does, Pick proper answer
    if topic && topics[topic]
      answer = topics[topic]

    # If target was specified, prepend with @mention
    if target
      answer = "@" + target.replace('@', '') + " " + answer

    # Send out answer
    msg.send answer

  # Hear for "hosting" keyword
  robot.hear /hosting/i, (msg) ->
    # Check if cooldown is currently active
    if !cooldown
      # If not, send message
      msg.send "Please send all hosting or hosted instance inquiries to `cloud@rocket.chat`. This is a _community support_ channel. Thank you for your understanding."

    # Activate cooldown
    cooldown = setTimeout(disableCooldown, cooldownInMinutes * 60 * 1000)
