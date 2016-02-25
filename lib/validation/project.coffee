@validateProject = (project) ->
  check project, Match.ObjectIncluding
    members: Match.Optional([String])
  errors = validateItem project
  if project.members?.length == 0
    if Meteor.isServer
      throw new Meteor.Error('invalid-project',
                             'You must select at least one project member')
    else
      errors.members = "Selecteer ten minste een projectlid"
  return errors

@validateProjectUpdate = (projectProperties) ->
  check projectProperties, Match.ObjectIncluding
    title: Match.Optional(String)
    members: Match.Optional([String])
  errors = {}
  if projectProperties.title? == ""
    if Meteor.isServer
      throw new Meteor.Error('invalid-project',
                             'You must add a title to a project')
    else
      errors.title = "Een titel is verplicht"
  if projectProperties.members?.length == 0
    if Meteor.isServer
      throw new Meteor.Error('invalid-project',
                             'You must select at least one project member')
    else
      errors.members = "Selecteer ten minste een projectlid"
  return errors
