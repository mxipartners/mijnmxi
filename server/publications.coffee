Meteor.publish 'projects', ->
  Projects.find {members: this.userId}
  
Meteor.publish 'notifications', ->
  Notifications.find {userId: this.userId}

Meteor.publish 'usernames', ->
  Meteor.users.find {}, {fields: {'username': 1, '_id': 1, 'show_tip': 1}}

Meteor.publish 'photos', ->
  Photos.find {userId: this.userId}
