Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> [Meteor.subscribe('projects'),
              Meteor.subscribe('usernames')]

Router.route '/projects/:_id/add_member',
  name: 'addMember'
  data: -> Projects.findOne this.params._id

Router.route '/project/:_project_id',
  name: 'editProject'
  template: 'project'
  data: ->
    project: Projects.findOne this.params._project_id
    user: Meteor.users.findOne Meteor.userId()
    mode: PageMode.edit

Router.route '/project/for/:_user_id',
  name: 'addProject'
  template: 'project'
  data: ->
    project: {}
    user: Meteor.users.findOne this.params._user_id
    mode: PageMode.create

Router.route '/projects/:_id',
  name: 'projectPage'
  data: -> Projects.findOne this.params._id
  subscriptions: -> Meteor.subscribe('messages', this.params._id)

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
