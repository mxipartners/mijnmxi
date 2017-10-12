Accounts.onCreateUser (options, user) ->
  tutorial =
    title: "Welkom bij Mijn M&I/Partners"
    description: "Mijn M&I/Partners is een applicatie om..."
    members: [user._id]
    userId: user._id
    submitted: new Date
    kind: 'project'
  projectId = Projects.insert tutorial
  message =
    project: projectId
    sender: user._id
    recipients: []
    content: "Hallo " + user.emails[0].address + ". Welkom bij Mijn M&I/Partners."
  Messages.insert message
  # Meteor.call("messageInsert", message)
  return user
