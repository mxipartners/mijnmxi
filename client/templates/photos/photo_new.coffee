Template.photoNew.onCreated ->
  Session.set 'photoNewErrors', {}


Template.photoNew.helpers
  userIsCurrentUser: -> this._id == Meteor.userId()
  errorMessage: (field) -> Session.get('photoNewErrors')[field]
  errorClass: (field) ->
    if Session.get('photoNewErrors')[field] then 'has-error' else ''

Template.photoNew.onRendered ->
  target = document.getElementById "fileinput"
  target.addEventListener "change", (event) ->
    for file in target.files
      do (file) ->
        console.log("Filename: " + file.name)
        console.log("Type: " + file.type)
        console.log("Size: " + file.size + " bytes")
        fileReader = new FileReader
        fileReader.onload = (evt) ->
          console.log (typeof evt.target.result)
        fileReader.readAsDataURL file

Template.photoNew.events
  'submit form': (e) ->
    target = document.getElementById "fileinput"
    for file in target.files
      do (file) ->
        console.log("Filename: " + file.name)
        console.log("Type: " + file.type)
        console.log("Size: " + file.size + " bytes")
        fileReader = new FileReader
        fileReader.onload = (evt) ->
          console.log (typeof evt.target.result)
          photo = { bitmap: evt.target.result }
          Meteor.call 'createPhoto', photo, (error, result) ->
            if error
              throwError error.reason
        fileReader.readAsDataURL file
    e.preventDefault()

  'click .cancel': (e) -> stop_submitting()


