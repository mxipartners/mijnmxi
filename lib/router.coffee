Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> [Meteor.subscribe('projects'),
              Meteor.subscribe('photos'),
              Meteor.subscribe('notifications'),
              Meteor.subscribe('usernames')]

Router.route '/projects/:_id',
  name: 'projectPage'
  data: -> Projects.findOne this.params._id

Router.route '/', name: 'home'

requireLogin = ->
  if Meteor.user()
    this.next()
  else
    this.render(if Meteor.loggingIn() then this.loadingTemplate else 'accessDenied')

Router.onBeforeAction requireLogin
