name = (user) ->
  if user._id == Meteor.userId()
    'Ik'
  else
    if user.name then user.name else user.emails[0].address

Template.messagesPage.helpers
  messages: ->
    Messages.find {}

  sender: ->
    name(Meteor.users.findOne({_id: @sender}))

  recipient_names: ->
    recipients = Meteor.users.find({'_id': {$in: @recipients}}).fetch()
    names = (name(recipient) for recipient in recipients)
    if names.length > 0 then names.join(', ') else 'Ik'

  selected_users: ->
    users = Meteor.users.find({'_id': {$in: Session.get('selectedItems')}}).fetch()
    (name(user) for user in users).join(', ')


Template.messagesPage.events
  'click .send_message': (e) ->
    e.preventDefault()
    messageProperties =
      project: this._id
      content: $('[name=messagecontent]').val()
      recipients: Session.get('selectedItems')
    Meteor.call 'messageInsert', messageProperties, (error, result) ->
      if error
        throwError error.reason
      else
<<<<<<< HEAD
        $('[name=messagecontent]').val('')
=======
        $(e.target).find('[name=messagecontent]').val('')

  'click .project_title': (e) ->
    e.preventDefault()
    Router.go 'projectPage', {_id: @_id}
>>>>>>> f6719606d16ba19720a35d8a93f8c05130d4ba5f
