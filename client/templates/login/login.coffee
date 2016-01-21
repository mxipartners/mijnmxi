Template.login.onCreated ->
  Session.set 'newUser', false

Template.login.helpers
  errorMessage: -> Session.get 'login'
  newUser: -> Session.get 'newUser'
  newUserButtonText: -> if Session.get 'newUser' then 'Annuleer' else 'Nieuwe gebruiker'
  loginButtonText: -> if Session.get 'newUser' then 'Registreer' else 'Login'


login = (email, password) ->
  Meteor.loginWithPassword email, password, (error) ->
    if error
      Session.set 'login', 'Email en/of wachtwoord fout'
    else
      Session.set 'login', null
      Router.go 'memberPage', {_id: Meteor.userId()}

register = (email, password, password2) ->
  if password != password2
    Session.set 'login', 'Wachtwoorden zijn niet gelijk'
  else
    Session.set 'login', null
    Session.set 'newUser', false
    Accounts.createUser {email: email, password: password}, (error) ->
      if error
        Session.set 'login', 'Email bestaat al'
      else
        Router.go 'memberPage', {_id: Meteor.userId()}

Template.login.events
  'submit form': (e) ->
    e.preventDefault()

    email = $(e.target).find('[name=email]').val()
    password = $(e.target).find('[name=password]').val()

    if Session.get 'newUser'
      password2 = $(e.target).find('[name=password2]').val()
      register email, password, password2
    else
      login email, password

  'click .new-user': (e) ->
    e.preventDefault()
    Session.set 'login', null
    Session.set('newUser', not Session.get 'newUser')
