Template.login.onCreated ->
  Session.set 'newUser', false
  if Accounts._resetPasswordToken
    Session.set 'resetPassword', Accounts._resetPasswordToken

Template.login.helpers
  errorMessage: -> Session.get 'errorMessage'
  newUser: -> Session.get 'newUser'
  resetPassword: -> Session.get 'resetPassword'
  newUserOrResetPassword: -> Session.get('newUser') or Session.get('resetPassword')
  newUserButtonText: -> if Session.get 'newUser' then 'Annuleer' else 'Nieuw'
  loginButtonText: ->
    if Session.get 'resetPassword'
      'Wijzig wachtwoord'
    else
      if Session.get 'newUser' then 'Registreer' else 'Login'


login = (email, password) ->
  Meteor.loginWithPassword email, password, (error) ->
    if error
      Session.set 'errorMessage', 'Email en/of wachtwoord fout'
    else
      Router.go 'memberPage', {_id: Meteor.userId()}

register = (email, password, password2) ->
  if password != password2
    Session.set 'errorMessage', 'Wachtwoorden zijn niet gelijk'
  else
    Session.set 'newUser', false
    Accounts.createUser {email: email, password: password}, (error) ->
      if error
        Session.set 'errorMessage', 'Email bestaat al'
      else
        Router.go 'memberPage', {_id: Meteor.userId()}

recover_password = (email) ->
  if not email
    Session.set 'errorMessage', 'Emailadres ontbreekt'
  else
    Accounts.forgotPassword {email: email}, (error) ->
      if error
        Session.set 'errorMessage', 'Fout bij email verzenden: ' + error
      else
        Session.set 'errorMessage', 'Email verzonden'

reset_password = (password, password2) ->
  if password != password2
    Session.set 'errorMessage', 'Wachtwoorden zijn niet gelijk'
  else
    Accounts.resetPassword Session.get('resetPassword'), password, (error) ->
      if error
        Session.set 'errorMessage', 'Fout bij wachtwoord herstellen: ' + error
      else
        Session.set 'resetPassword', null
        Accounts._resetPasswordToken = null
        Router.go 'memberPage', {_id: Meteor.userId()}

Template.login.events
  'submit form': (e) ->
    e.preventDefault()
    Session.set 'errorMessage', null

    if not Session.get 'resetPassword'
      email = $(e.target).find('[name=email]').val()

    password = $(e.target).find('[name=password]').val()

    if Session.get('newUser') or Session.get('resetPassword')
      password2 = $(e.target).find('[name=password2]').val()

    if Session.get 'resetPassword'
      reset_password password, password2
    else if Session.get 'newUser'
      register email, password, password2
    else
      login email, password

  'click .new-user': (e) ->
    e.preventDefault()
    Session.set 'errorMessage', null
    Session.set('newUser', not Session.get 'newUser')

  'click .password-recovery': (e) ->
    e.preventDefault()
    Session.set 'errorMessage', null
    email = Template.instance().$('[name=email]').val()
    recover_password email
