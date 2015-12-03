Meteor.publish 'projects', ->
  Projects.find {members: this.userId}

Meteor.publish 'notifications', ->
  Notifications.find {userId: this.userId}

Meteor.publish 'usernames', ->
  Meteor.users.find {}, {fields: {'emails': 1, '_id': 1, 'telephone_nr': 1, 'skype_id', 1}}

Meteor.publish 'photos', (projectId) ->
  if projectId?
    check projectId, String
    Photos.find { projectId: projectId }, { sort: { uploadTimestamp: -1 }}
  else
    []
