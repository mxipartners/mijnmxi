Template.footer.helpers
  selected_members_skype_ids: ->
    members = Session.get 'selectedMembers'
    console.log(members)
    selected_users = Meteor.users.find {_id: {$in: members}}
    console.log(selected_users.fetch())
    skype_ids = (user.skype_id for user in selected_users when user.skype_id)
    return skype_ids.join(';')
