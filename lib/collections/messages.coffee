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
    messageId = Messages.insert message

#Testcode, send a notification (to every user connected) about the new message
    Push.send({
      title: 'Nieuw bericht',
      text: 'Lees het nu!',
      from: 'server',
      query: {},
      gcm: {
        style: 'inbox',
        summaryText: 'Er zijn %n% berichten'
      }
    });
    return {_id: messageId}
