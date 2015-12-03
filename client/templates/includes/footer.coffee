Template.footer.helpers
  selected_members_skype_ids: ->
    members = Session.get 'selectedMembers'
    selected_users = Meteor.users.find({_id: {$in: members}}).fetch()
    skype_ids = (user.skype_id for user in selected_users when user.skype_id)
    return skype_ids.join(';')

Template.footer.events
  'click .logout': (e) ->
    e.preventDefault()
    Meteor.logout()
    Router.go 'home'
