Meteor.publish 'projects', ->
  Projects.find {members: this.userId}

Meteor.publish 'usernames', ->
  Meteor.users.find {}, {fields: {'emails': 1, '_id': 1, 'telephone_nr': 1, 'skype_id': 1, 'name': 1}}
