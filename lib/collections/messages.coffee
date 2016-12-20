@Messages = new Mongo.Collection 'messages'

Messages.allow
  insert: (userId, message) -> isProjectMember userId, Projects.findOne(message.projectId)

Meteor.methods
  messageInsert: (messageAttributes) ->
    check Meteor.userId(), String
    validateMessage messageAttributes
    message = _.extend messageAttributes,
      sender: Meteor.userId()
      sent: new Date()
    message.recipients = message.recipients.filter((recipient) -> recipient != Meteor.userId())
    messageId = Messages.insert message
    return {_id: messageId}
