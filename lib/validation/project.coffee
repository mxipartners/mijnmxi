@validateProject = (project) ->
  check project, Match.ObjectIncluding
    members: [String]
  errors = validateItem project
  if project.members.length == 0
    if Meteor.isServer
      throw new Meteor.Error('invalid-project',
                             'You must select at least one project member')
    else
      errors.members = "Selecteer ten minste een projectlid"
  return errors
