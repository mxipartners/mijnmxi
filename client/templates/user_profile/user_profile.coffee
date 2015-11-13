Template.profilePage.events
  'submit form': (e) ->
    e.preventDefault()

    telephone_nr = $(e.target).find('[name=telephone_nr]').val()
    skype_id = $(e.target).find('[name=skype_id]').val()

    Meteor.users.update this._id, {$set: {telephone_nr: telephone_nr}}
    Meteor.users.update this._id, {$set: {skype_id: skype_id}}
    Router.go 'home'

  'click .cancel': (e) -> Router.go 'home'
 