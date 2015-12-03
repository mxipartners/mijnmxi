Template.accessDenied.helpers
  errorMessage: -> Session.get('login')
  errorClass: -> if Session.get('login') then 'has-error' else ''


Template.accessDenied.events
  'submit form': (e) ->
    e.preventDefault()

    email = $(e.target).find('[name=email]').val()
    password = $(e.target).find('[name=password]').val()
    console.log email, password

    Meteor.loginWithPassword email, password, (error) ->
      if error
        console.log error
        Session.set 'login', 'Email en/of wachtwoord fout'
      else
        Session.set 'login', null
        console.log 'Success!'
        Router.go 'home'
