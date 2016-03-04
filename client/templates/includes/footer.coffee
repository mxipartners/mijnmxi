selected_users = ->
  members = Session.get 'selectedItems'
  if !members
    members = []
  Meteor.users.find({_id: {$in: members}}).fetch()


Template.footer.helpers
  selected_users: -> selected_users()
  one_selected_user: -> selected_users().length == 1
  project_or_member_page: ->
    Router.current().route.getName() in ["projectPage", "memberPage"]

  phone_url: ->
    users = selected_users()
    if users.length == 0
      "#"
    else if users.length == 1
      phone_number = users[0].telephone_nr
      "tel:#{phone_number}"
    else
      skype_ids = (user.skype_id for user in users when user.skype_id).join(';')
      "skype:#{skype_ids}?call"

  sms_url: ->
    users = selected_users()
    if users.length == 0
      "#"
    else if users.length == 1
      phone_number = users[0].telephone_nr
      "sms:#{phone_number}"
    # "whatsapp://send?abid=#{phone_number}"

Template.footer.events
  'click .logout': (e) ->
    e.preventDefault()
    Meteor.logout()
    Router.go '/'

  'click .add': (e) ->
    e.preventDefault()
    if Router.current().route.getName() == "projectPage"
      Router.go 'addMember', {_id: Router.current().params._id}
    else if Router.current().route.getName() == "memberPage"
      Router.go 'addProject', {_id: Router.current().params._id}
