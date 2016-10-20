Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> [Meteor.subscribe('projects'),
              Meteor.subscribe('usernames')]

Router.route '/projects/:_id/add_member',
  name: 'addMember'
  data: -> Projects.findOne this.params._id

Router.route '/projects/:_id/edit',
  name: 'projectEdit'
  data: -> Projects.findOne this.params._id

Router.route '/projects/:_id',
  name: 'projectPage'
  data: -> Projects.findOne this.params._id
  subscriptions: -> Meteor.subscribe('messages', this.params._id)

Router.route '/members/:_id/add_project',
  name: 'addProject'
  data: -> Meteor.users.findOne this.params._id

Router.route '/members/:_id',
  name: 'memberPage'
  data: -> Meteor.users.findOne this.params._id

Router.route '/projects/:_id/messages',
  name: 'messagesPage'
  data: -> Projects.findOne this.params._id
  subscriptions: -> Meteor.subscribe('messages', this.params._id)

Router.route '/users/:_id',
  name: 'profilePage'
  data: -> Meteor.users.findOne this.params._id

Router.route '/', ->
  if Meteor.user()
    this.redirect 'memberPage', {_id: Meteor.userId()}
  else:
    this.render 'login'

requireLogin = ->
  if Meteor.user()
    this.next()
  else
    this.render(if Meteor.loggingIn() then this.loadingTemplate else 'login')

Router.onBeforeAction requireLogin
