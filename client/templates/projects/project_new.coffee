Template.projectNew.onCreated ->
  Session.set 'projectNewErrors', {}

Template.projectNew.helpers
  errorMessage: (field) -> Session.get('projectNewErrors')[field]
  errorClass: (field) ->
    if Session.get('projectNewErrors')[field] then 'has-error' else ''


Template.projectNew.events
  'submit form': (e) ->
    e.preventDefault()

    project =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      members: [Meteor.user()._id]

    Session.set 'project_title', {}
    Session.set 'projectNewErrors', {}
    errors = validateProject project
    if errors.title
      Session.set 'project_title', errors
    if errors.members
      Session.set 'projectNewErrors', errors
    if errors.title
      return false

    Meteor.call 'projectInsert', project, (error, result) ->
      if error
        throwError error.reason
      else
        stop_submitting()
        Router.go 'projectPage', {_id: result._id}

  'click .cancel': (e) -> stop_submitting()
