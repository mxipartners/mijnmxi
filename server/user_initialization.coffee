Accounts.onCreateUser (options, user) ->
  tutorial =
    title: "Welkom bij Mijn M&I/Partners"
    description: "Mijn M&I/Partners is een applicatie om..."
    members: [user._id]
    userId: user._id
    submitted: new Date
    kind: 'project'
  projectId = Projects.insert tutorial
  return user
