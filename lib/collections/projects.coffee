@Projects = new Mongo.Collection "projects"

Projects.allow
  update: (userId, project) -> isProjectMember userId, project
  remove: (userId, project) -> isProjectMember userId, project

Projects.deny
  update: (userId, project, fieldNames) ->
    # may only edit the following fields:
    _.without(fieldNames, "title", "description", "members").length > 0

Projects.deny
  update: (userId, project, fieldNames, modifier) ->
    if modifier.$set == undefined
      return ""
    errors = validateProjectUpdate modifier.$set
    return errors.title or errors.members

Meteor.methods
  projectInsert: (projectAttributes) ->
    check Meteor.userId(), String
    validateProject projectAttributes
    user = Meteor.user()
    project = _.extend projectAttributes,
      userId: user._id
      submitted: new Date()
      kind: "project"
    projectId = Projects.insert project
    return {_id: projectId}
  projectRemoveMember: (projectId, userId) ->
    check projectId, String
    check userId, String
    project = Projects.findOne projectId
    if project
      members = (member for member in project.members when member != userId)
      if members.length > 0
        Projects.update projectId, {$set: {members: members}}, (error) ->
          if error
            # FIXME: how to get errror to client?
            throwError error.reason
      else
        Projects.remove projectId, (error) ->
          if error
            # FIXME: how to get errror to client?
            throwError error.reason
