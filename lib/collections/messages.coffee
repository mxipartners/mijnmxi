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
    project = Projects.findOne(message.project)
    Meteor.call("updateUnreadItems", project, messageId, (error, result) ->
      if error
        throwError(error)
    )

    if message.recipients.length is 0
      project = Projects.findOne(message.project)
      message.recipients = project.members

    Push.send({
      title: 'Nieuw bericht in MijnMxI',
      text: message.content,
      from: 'server',
      query: {
        userId: recipient
      }
    }) for recipient in message.recipients;

    return {_id: messageId}
