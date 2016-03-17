gravatar_url = (email_address) ->
  hash = CryptoJS.MD5 email_address.trim().toLowerCase()
  "http://www.gravatar.com/avatar/" + hash + "?d=404&s=50"

Template.profilePage.onRendered ->
  url = gravatar_url(Template.parentData().emails[0].address)
  HTTP.get url, (error, response) ->
    # If you're wondering why there's a 404 exception in the console log,
    # see https://github.com/meteor/meteor/issues/6215
    if not error
      $('#gravatar_help').html('<img class="img-circle" src="' + url + '"/>
        <p>Uw avatar zoals geregistreerd bij
        <a href="http://gravatar.com">gravatar.com</a>.</p>')

Template.profilePage.helpers
  email: -> @emails[0].address
  readonly: -> if @_id == Meteor.userId() then '' else 'readonly'

Template.profilePage.events
  'submit form': (e) ->
    e.preventDefault()

    if @_id == Meteor.userId()
      name = $('[name=name]').val()
      telephone_nr = $('[name=telephone_nr]').val()
      skype_id = $('[name=skype_id]').val()
      Meteor.users.update @_id, {$set: { name: name, telephone_nr: telephone_nr, skype_id: skype_id }}

    Router.go 'memberPage', {_id: @_id}

  'click .cancel': (e) ->
    e.preventDefault()
    Router.go 'memberPage', {_id: @_id}
