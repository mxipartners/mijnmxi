Template.projectPage.onCreated ->
  self = this
  this.autorun(() ->
    view = self.view
    if not view
      console.log("NO VIEW in project page (show 'home' page)")
      return
    data = Template.currentData(view)
    if not data
      console.log("NO DATA in project page", data)
      Router.go "memberPage", {_id: Meteor.userId()}
      return
    self.project = data

    # Read all users for current project (into array)
    users = Meteor.users.find({_id: {$in: data.members}}).map((x) -> x)

    # Find current user
    currentUserId = Meteor.userId()
    currentUserIndex = users.reduce(((index, user, i) ->
      if index >= 0
        return index
      else if user._id == currentUserId
        return i
      return -1), -1)

    # Remove current user from array and store it separately
    currentUser = users.splice(currentUserIndex, 1)[0]

    # Sort remaining users based on main email address
    users.sort((a, b) -> a.emails[0].address.localeCompare(b.emails[0].address))

    # Insert current user at front
    users.splice(0,  0, currentUser)

    # Store result in session
    Session.set("items", users)
  )
  this.subject = ->
    this.project
  this.subjectTitle = ->
    messageCount = Messages.find().count()
    this.project.title + (if messageCount > 0 then " (" + messageCount + ")" else "")
  this.subjectIcon = ->
    "#project"
  this.subjectEmailAddress = ->
    null
  this.subjectEditTemplate = ->
    "messagesPage"
  this.subjectEditParameters = (subject) ->
    { _project_id: subject._id }
  this.subjectLongPressEditTemplate = ->
    "editProject"
  this.subjectLongPressEditParameters = (subject) ->
    { _project_id: subject._id }
  this.relatedItemTitle = (user) ->
    user.name || user.emails[0].address.replace(/@.*$/, "")
  this.relatedItemIcon = (user) ->
    "#person"
  this.relatedItemEmailAddress = (user) -> 
    emails = user.emails
    if emails && emails.length > 0
      emails[0].address
    else
      null
  this.relatedItemTemplate = (user)->
    "memberPage"
  this.removeItemRelation = (user) ->
    Meteor.call("projectRemoveMember", this.project._id, user._id, (error, result) ->
      console.log(error, result)
    )
