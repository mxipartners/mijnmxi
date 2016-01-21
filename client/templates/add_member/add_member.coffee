Template.addMember.helpers
  email: -> @emails[0].address
  users: -> Meteor.users.find {}
  userIsMember: ->
    project = Template.parentData()
    this._id in project.members

Template.addMember.events
  'submit form': (e) ->
    e.preventDefault()
    projectId = this._id
    projectProperties =
      members: $(e.target).find('[name=members]').val() or []
    Projects.update this._id, {$set: projectProperties}, (error) ->
      if error
        console.log error.reason
        throwError error.reason
      else
        Router.go 'projectPage', {_id: projectId}

  'click .cancel': (e) ->
    Router.go 'projectPage', {_id: this._id}
