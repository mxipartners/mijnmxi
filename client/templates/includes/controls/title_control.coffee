Template.titleControl.onCreated ->
  Session.set Template.currentData().control_id, {}

errorMessage = (field) ->
  Session.get(Template.currentData().control_id)[field]

Template.titleControl.helpers
  errorMessage: errorMessage

  errorClass: (field) ->
    if errorMessage(field) then 'has-error' else ''
