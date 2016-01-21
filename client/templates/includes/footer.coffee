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
    Router.go '/'

  'click .add': (e) ->
    e.preventDefault()
    if Router.current().route.getName() == "projectPage"
      Router.go 'addMember', {_id: Router.current().params._id}
    else
      project =
        title: 'Nieuw project'
        members: [Meteor.user()._id]
      Meteor.call 'projectInsert', project, (error, result) ->
        if error
          throwError error.reason
        else
          Router.go 'projectEdit', {_id: result._id}
