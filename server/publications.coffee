Meteor.publish 'projects', ->
  Projects.find {members: this.userId}

Meteor.publish 'messages', (projectId) ->
  check projectId, String
  # Find all messages for the current project which have our user as sender or recipient
  Messages.find {project: projectId}
  # {$and: [{$or: [{recipients: this.userId}, {sender: this.userId}]}, {project: this.projectId}]}

Meteor.publish 'usernames', ->
  Meteor.users.find {}, {fields: {'emails': 1, '_id': 1, 'telephone_nr': 1, 'skype_id': 1, 'name': 1}}
