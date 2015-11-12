Template.photoNew.onCreated ->
  Session.set 'photoNewErrors', {}


Template.photoNew.helpers
  userIsCurrentUser: -> this._id == Meteor.userId()
  errorMessage: (field) -> Session.get('photoNewErrors')[field]
  errorClass: (field) ->
    if Session.get('photoNewErrors')[field] then 'has-error' else ''


Template.photoNew.events
  'submit form': (e) ->
    console.log($(e.target).find('[name=bitmap]').val())
    e.preventDefault()

    file = $(e.target).find('[name=bitmap]').val()
    reader = new FileReader()
    reader.onload = (f) ->
        createPhoto {bitmap:f.target.result}

  'click .cancel': (e) -> stop_submitting()


