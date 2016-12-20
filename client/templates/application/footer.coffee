selected_users = ->
  members = Session.get 'selectedItems'
  if !members
    members = []
  Meteor.users.find({_id: {$in: members}}).fetch()

phone_url = ->
  users = selected_users()
  if users.length == 0
    "#"
  else if users.length == 1
    phone_number = users[0].telephone_nr
    "tel:#{phone_number}"
  else
    skype_ids = (user.skype_id for user in users when user.skype_id).join(';')
    "skype:#{skype_ids}?call"

Template.footer.helpers
  selected_users: -> selected_users()
  one_selected_user: -> selected_users().length == 1
  project_or_member_page: ->
    Router.current().route.getName() in ["projectPage", "memberPage"]

  sms_url: ->
    users = selected_users()
    if users.length == 0
      "#"
    else if users.length == 1
      phone_number = users[0].telephone_nr
      "sms:#{phone_number}"
    # "whatsapp://send?abid=#{phone_number}"

Template.footer.events
  # Use 'click .me_focus button' (and the like) if pressing next to button is undesired (limiting the press to exactly the icon)
  'click .control.me_focus': (e) ->
    e.preventDefault()
    Router.go 'memberPage', {_id: Meteor.userId }

  'click .control.call': (e) ->
    e.preventDefault()
    phoneUrl = phone_url()
    if phoneUrl && phoneUrl != "#"
      window.location.href = phone_url()

  'click .control.add': (e) ->
    e.preventDefault()
    # FIXME: new approach to handle 'add' in own context (no need to know about current page and such)
    #if window.addHandler
    #  window.addHandler 'clicked'
    #else
    #  window.alert "Huh?!"
    if Router.current().route.getName() == "projectPage"
      Router.go 'addMember', {_id: Router.current().params._id}
    else if Router.current().route.getName() == "memberPage"
      Router.go 'addProject', {_user_id: Router.current().params._id}

  'click .control.message': (e) ->
    e.preventDefault()
    if Router.current().route.getName() == "projectPage"
      Router.go 'messagesPage', {_project_id: Router.current().params._id}
