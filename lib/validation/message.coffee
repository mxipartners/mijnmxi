@validateMessage = (message) ->
  check message, Match.ObjectIncluding
    recipients: Match.Optional([String])
  return {}
