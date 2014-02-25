# Description:
#   A cuss jar, but for puns.
#
# Dependencies:
#   "hubot-cookiejar": ">= 0.0.1"
#
# Configuration:
#   None
#
# Commands:
#   sab punjar <name> - Force a user to deposit $1 into the pun jar.
#   sab punjar open - See the contents of the pun jar.
#
# Author:
#   jonursenbach

{CookieJar} = require('hubot-cookiejar')

module.exports = (robot) ->
  robot.respond /punjar (.*)/i, (msg) ->
    cookiejar = new CookieJar 'puns', robot

    user = msg.match[1].trim()
    if user != ""
      if user != 'open'
        user = getUser robot, user

        cookiejar.increment(user)

        msg.send user + ' was forced to deposit $1 into the pun jar.'
        return

      size = 0
      emit = 'Contents of the pun jar:\n'
      cookies = cookiejar.summary()

      if cookies.length == 0
        msg.send 'The pun jar is empty!'
        return

      for sorted in cookies
        emit += ' - ' + sorted.item + ': $' + sorted.total + '\n'

      msg.send emit

getUser = (robot, user) ->
  users = robot.brain.usersForFuzzyName(user)
  if users.length is 1
    user = users[0]
    return user.name.replace(/[\s](.*)/, '')

  return user
