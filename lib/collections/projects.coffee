@Projects = new Mongo.Collection 'projects'

Projects.allow
  update: (userId, project) -> isProjectMember userId, project
  remove: (userId, project) -> isProjectMember userId, project

Projects.deny
  update: (userId, project, fieldNames) ->
    # may only edit the following fields:
    _.without(fieldNames, 'title', 'description', 'members').length > 0

Projects.deny
  update: (userId, project, fieldNames, modifier) ->
    if modifier.$set == undefined
      return ""
    errors = validateProject modifier.$set
    return errors.title or errors.members

Meteor.methods
  projectInsert: (projectAttributes) ->
    check Meteor.userId(), String
    validateProject projectAttributes
    user = Meteor.user()
    project = _.extend projectAttributes,
      userId: user._id
      submitted: new Date()
      kind: 'project'
    projectId = Projects.insert project
    return {_id: projectId}
