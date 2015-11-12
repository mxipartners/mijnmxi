Template.header.events
  'click a.profile': (e) ->
    e.preventDefault()
    Router.go 'profilePage', {_id: Meteor.userId}
