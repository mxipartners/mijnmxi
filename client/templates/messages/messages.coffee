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
    names = (name(recipient) for recipient in @recipients)
    if names.length > 0 then names.join(', ') else 'Ik'

  selected_users: ->
    users = Meteor.users.find({'_id': {$in: Session.get('selectedItems')}}).fetch()
    (name(user) for user in users).join(', ')
