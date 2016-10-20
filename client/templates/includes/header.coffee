Template.header.events
  'click .control.call': (e) ->
    e.preventDefault()
    window.location.href = "tel:+31302270500"

  'click .control.logout': (e) ->
    e.preventDefault()
    Meteor.logout ->
      Router.go '/'
