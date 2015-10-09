Accounts.onCreateUser (options, user) ->
  tutorial =
    title: "Welcome to Mijn M&I/Partners, #{user.username}!"
    description: "Mijn M&I/Partners is ..."
    members: [user._id]
    userId: user._id
    submitted: new Date
    kind: 'project'
  projectId = Projects.insert tutorial
  project = Projects.findOne({_id: projectId})
  return user
