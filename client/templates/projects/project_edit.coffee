Template.projectEditOld.onCreated ->
  Session.set 'projectEditErrors', {}

Template.projectEditOld.helpers
  errorMessage: (field) ->
    Session.get('projectEditErrors')[field]
  errorClass: (field) ->
    if Session.get('projectEditErrors')[field] then 'has-error' else ''

Template.projectEditOld.events
  'submit form': (e) ->
    e.preventDefault()

    projectProperties =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()

    Session.set 'project_title', {}
    Session.set 'projectEditErrors', {}
    errors = validateProject projectProperties

    if errors.title
      Session.set 'project_title', errors
    if errors.members
      Session.set 'projectEditErrors', errors
    if errors.title
      return false

    Projects.update this._id, {$set: projectProperties}, (error) ->
      if error
        throwError error.reason
      else
        stop_editing()

  'click .cancel': (e) -> stop_editing()


Template.deleteProject.events
  'click .delete': (e) ->
    remove_project = =>
      Projects.remove this._id
      Router.go 'home'
    # Make sure the backdrop is hidden before we do anything.
    $('#deleteProject').modal('hide').on('hidden.bs.modal', remove_project)
