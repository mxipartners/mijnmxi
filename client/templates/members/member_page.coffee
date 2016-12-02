Template.memberPage.onCreated ->
  self = this
  this.autorun(() ->
    view = self.view
    if not view
      console.log("NO VIEW in member page")
      return
    data = Template.currentData(view)
    if not data
      console.log("NO DATA in member page (show 'home' page)")
      Router.go "memberPage", {_id: Meteor.userId()}
      return
    self.user = data
    Session.set("items", Projects.find({members: data._id}).map((x) -> x))
  )
  this.subject = ->
    this.user
  this.subjectTitle = ->
    this.user.name || this.user.emails[0].address.replace(/@.*$/, "")
  this.subjectIcon = ->
    "#person"
  this.subjectEmailAddress = ->
    emails = this.user.emails
    if emails && emails.length > 0
      emails[0].address
    else
      null
  this.subjectEditTemplate = ->
    "profilePage"
  this.relatedItemTitle = (project) ->
    project.title
  this.relatedItemIcon = (project) ->
    "#project"
  this.relatedItemEmailAddress = (project) ->
    null
  this.relatedItemTemplate = (project) ->
    "projectPage"
  this.removeItemRelation = (project) ->
    Meteor.call("projectRemoveMember", project._id, this.user._id, (error, result) ->
      console.log(error, result)
    )