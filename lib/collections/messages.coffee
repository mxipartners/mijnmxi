@Messages = new Mongo.Collection 'messages'

Messages.allow
  update: (userId, project) -> isProjectMember userId, project

Meteor.methods
  messageInsert: (messageAttributes) ->
    check Meteor.userId(), String
    validateMessage messageAttributes
    user = Meteor.user()
    message = _.extend messageAttributes,
      sender: user._id
      sent: new Date()
    messageId = Messages.insert message
    return {_id: messageId}
