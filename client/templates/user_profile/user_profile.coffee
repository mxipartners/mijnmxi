Template.profilePage.events
  'submit form': (e) ->
    e.preventDefault()

    telephone_nr = $(e.target).find('[name=telephone_nr]').val()

    Meteor.users.update this._id, {$set: {telephone_nr: telephone_nr}}
    Router.go 'home'

  'click .cancel': (e) -> Router.go 'home'
