Accounts.onCreateUser (options, user) ->
  user.telephone_nr = '123456'
  tutorial =
    title: "Welcome to Mijn M&I/Partners, #{user.username}!"
    description: "Mijn M&I/Partners is #{user.telephone_nr}..."
    members: [user._id]
    userId: user._id
    submitted: new Date
    kind: 'project'
  projectId = Projects.insert tutorial
  return user
