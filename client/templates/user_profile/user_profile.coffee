Template.profilePage.helpers
  email: -> @emails[0].address
  readonly: -> if @_id == Meteor.userId() then '' else 'readonly'

Template.profilePage.events
  'submit form': (e) ->
    e.preventDefault()

    if @_id == Meteor.userId()
      telephone_nr = $(e.target).find('[name=telephone_nr]').val()
      skype_id = $(e.target).find('[name=skype_id]').val()
      Meteor.users.update @_id, {$set: {telephone_nr: telephone_nr, skype_id: skype_id}}

    Router.go 'memberPage', {_id: @_id}

  'click .cancel': (e) ->
    e.preventDefault()
    Router.go 'memberPage', {_id: @_id}
