Template.photoNew.onCreated ->
  Session.set 'photoNewErrors', {}
  Session.setDefault "photosUploaded", false

Template.photoNew.helpers
  userIsCurrentUser: -> this._id == Meteor.userId()
  photosUploaded: ->
    Session.get "photosUploaded"
  errorMessage: (field) -> Session.get('photoNewErrors')[field]
  errorClass: (field) ->
    if Session.get('photoNewErrors')[field] then 'has-error' else ''
  selectedMemberCount: ->
    console.log (Session.get "selectedMembers")
    return (Session.get "selectedMembers").length

Template.photoNew.onRendered ->
  Session.set "photosUploaded", false
  target = document.getElementById "fileinput"
  target.addEventListener "change", (event) ->
    Session.set "photosUploaded", true
#    for file in target.files
#      do (file) ->
#        console.log("Filename: " + file.name)
#        console.log("Type: " + file.type)
#        console.log("Size: " + file.size + " bytes")
#        fileReader = new FileReader
#        fileReader.onload = (evt) ->
#          console.log (typeof evt.target.result)
#        fileReader.readAsDataURL file

Template.photoNew.events
  'submit form': (e) ->
    target = document.getElementById "fileinput"
    project = Template.parentData()
    for file in target.files
      do (file) ->
        fileReader = new FileReader
        fileReader.onload = (evt) ->
          photo = { bitmap: evt.target.result, projectId: project._id }
          Meteor.call 'createPhoto', photo, (error, result) ->
            if error
              stop_submitting
              throwError error.reason
        fileReader.readAsDataURL file
    e.preventDefault()

  'click .cancel': (e) -> stop_submitting()
