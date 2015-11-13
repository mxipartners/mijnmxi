Accounts.onCreateUser (options, user) ->
  tutorial =
    title: "Welcome to Mijn M&I/Partners, #{user.username}!"
    description: "Mijn M&I/Partners is een applicatie om..."
    members: [user._id]
    userId: user._id
    submitted: new Date
    kind: 'project'
  projectId = Projects.insert tutorial
  return user
