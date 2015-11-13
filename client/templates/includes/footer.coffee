Template.footer.helpers
  selected_members_skype_ids: ->
    members = Session.get 'selectedMembers'
    skype_ids = (member.skype_id for member in members when member.skype_id)
    return skype_ids.join(';')
