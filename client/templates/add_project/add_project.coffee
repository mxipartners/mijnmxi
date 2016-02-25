Template.addProject.events
  'submit form': (e) ->
    e.preventDefault()
    members = [Meteor.userId()]
    if this._id not in members
      members.push this._id
    projectProperties =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      members: members
    Meteor.call 'projectInsert', projectProperties, (error, result) ->
      if error
        throwError error.reason
      else
        Router.go 'projectPage', {_id: result._id}

  'click .cancel': (e) ->
    Router.go 'memberPage', {_id: this._id}
