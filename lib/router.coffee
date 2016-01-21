Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> [Meteor.subscribe('projects'),
              Meteor.subscribe('notifications'),
              Meteor.subscribe('usernames')]

Router.route '/projects/:_id/add_member',
  name: 'addMember'
  data: -> Projects.findOne this.params._id

Router.route '/projects/:_id',
  name: 'projectPage'
  data: -> Projects.findOne this.params._id

Router.route '/users/:_id',
  name: 'profilePage'
  data: -> Meteor.users.findOne this.params._id

Router.route '/', name: 'home'

requireLogin = ->
  if Meteor.user()
    this.next()
  else
    this.render(if Meteor.loggingIn() then this.loadingTemplate else 'login')

Router.onBeforeAction requireLogin
