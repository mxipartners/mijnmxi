Meteor.publish 'projects', ->
    Projects.find {members: this.userId}

Meteor.publish 'channels', ->
    UserChannels.find({ userId: this.userId })

Meteor.publish 'projectMessages', (projectId) ->
    check projectId, String
    # Find all messages for the current project which have our user as sender or recipient
    Messages.find({$and: [{$or: [{recipients: {$in: [this.userId]}}, {recipients: {$size: 0}}, {sender: this.userId}]}, {project: projectId}]}, {sort: { sent: 1}})

Meteor.publish 'allMessages', ->
    Messages.find({$or: [{recipients: {$in: [this.userId]}}, {recipients: {$size: 0}}, {sender: this.userId}]}, {sort: {sent: 1}})

Meteor.publish 'usernames', ->
    Meteor.users.find {}, {fields: {'emails': 1, '_id': 1, 'telephone_nr': 1, 'skype_id': 1, 'name': 1}}
