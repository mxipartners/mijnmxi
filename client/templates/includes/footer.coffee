Template.footer.helpers
  phone_url: ->
    members = Session.get 'selectedMembers'
    selected_users = Meteor.users.find({_id: {$in: members}}).fetch()
    if selected_users.length == 0
      "#"
    else if selected_users.length == 1
      phone_number = selected_users[0].telephone_nr
      "tel:#{phone_number}"
    else
      skype_ids = (user.skype_id for user in selected_users when user.skype_id).join(';')
      "skype:#{skype_ids}?call"

Template.footer.events
  'click .logout': (e) ->
    e.preventDefault()
    Meteor.logout()
    Router.go 'home'

  'click .add_member': (e) ->
    e.preventDefault()
    Session.set 'add_members', not Session.get 'add_members'
