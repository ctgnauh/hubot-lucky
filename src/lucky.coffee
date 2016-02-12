# Description
#   A hubot script that test your luck
#
# Commands:
#   hubot roll my luck - Reply with your luck
#
# Author:
#   ctgnauh <huangtc@outlook.com>

_ = require "underscore"

lucks = ['大吉', '中吉', '小吉', '吉', '末吉', '凶', '大凶']

module.exports = (robot) ->
  robot.respond /roll my luck/, (msg) ->
    now = new Date
    timestamp = now.getTime()
    user = msg.message.user.name

    luckHistory = robot.brain.get("luck-history") or {}
    if _.keys(luckHistory).length is 0
      luckHistory[user] = {timestamp: -1, luck: -1}

    if timestamp >= luckHistory[user].timestamp + 86400000
      result = msg.random lucks
      resultIndex = lucks.indexOf result
      luckHistory[user] = {timestamp: timestamp, luck: resultIndex}
      robot.brain.set "luck-history", luckHistory
      robot.logger.info "new day new luck"
      msg.reply "Today your luck is #{result}"
    else
      msg.reply "You have been tested luck. Your luck is #{lucks[luckHistory[user].luck]}"
