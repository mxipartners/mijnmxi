Template.addMember.helpers
  email: -> @emails[0].address
  users: ->
    project = Template.parentData()
    Meteor.users.find {_id: {$nin: project.members}}

Template.addMember.events
  'submit form': (e) ->
    e.preventDefault()
    projectId = this._id
    project = Projects.findOne projectId
    extra_members = $(e.target).find('[name=members]').val() or []
    projectProperties =
      members: project.members.concat extra_members
    Projects.update projectId, {$set: projectProperties}, (error) ->
      if error
        throwError error.reason
      else
        Router.go 'projectPage', {_id: projectId}

  'click .cancel': (e) ->
    Router.go 'projectPage', {_id: this._id}
