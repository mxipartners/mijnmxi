Template.projectEdit.events
  'submit form': (e) ->
    e.preventDefault()
    projectId = this._id
    projectProperties =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
    Projects.update this._id, {$set: projectProperties}, (error) ->
      if error
        throwError error.reason
      else
        Router.go 'projectPage', {_id: projectId}

  'click .cancel': (e) ->
    Router.go 'projectPage', {_id: this._id}
