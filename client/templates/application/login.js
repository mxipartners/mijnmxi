Template.login.onCreated(function() {
  Session.set('newUser', false);
  if(Accounts._resetPasswordToken) {
    console.log("Token: " + Accounts._resetPasswordToken);
    Session.set('resetPassword', Accounts._resetPasswordToken);
  }
});

Template.login.helpers({
  errorMessage: function() {
    return Session.get('errorMessage');
  },
  newUser: function() {
    return Session.get('newUser');
  },
  resetPassword: function() {
    return Session.get('resetPassword');
  },
  newUserOrResetPassword: function() {
    return Session.get('newUser') || Session.get('resetPassword');
  },
  newUserButtonText: function() {
    return Session.get('newUser') ? 'Annuleer' : 'Nieuw';
  },
  loginButtonText: function() {
    if(Session.get('resetPassword')) {
      return 'Wijzig wachtwoord';
    } else {
      return Session.get('newUser') ? 'Registreer' : 'Login';
    }
  }
});

var login = function(email, password) {
  Meteor.loginWithPassword(email, password, function(error) {
    if(error) {
      Session.set('errorMessage', 'Email en/of wachtwoord fout');
    } else {
      Router.go('memberPage', { _id: Meteor.userId() });
    }
  });
};

var register = function(email, password, password2) {
  if(password !== password2) {
    Session.set('errorMessage', 'Wachtwoorden zijn niet gelijk');
  } else {
    Session.set('newUser', false);
    Accounts.createUser({ email: email, password: password }, function(error) {
      if(error) {
        Session.set('errorMessage', 'Email bestaat al');
      } else {
        Router.go('memberPage', { _id: Meteor.userId() });
      }
    });
  }
};

var recoverPassword = function(email) {
  if(!email) {
    Session.set('errorMessage', 'Emailadres ontbreekt');
  } else {
    Accounts.forgotPassword({ email: email }, function(error) {
      if(error) {
        Session.set('errorMessage', 'Fout bij email verzenden: ' + error);
      } else {
        Session.set('errorMessage', 'Email verzonden');
      }
    });
  }
};

var resetPassword = function(password, password2) {
  if(password !== password2) {
    Session.set('errorMessage', 'Wachtwoorden zijn niet gelijk');
  } else {
    Accounts.resetPassword(Session.get('resetPassword'), password, function(error) {
      if(error) {
        Session.set('errorMessage', 'Fout bij wachtwoord herstellen: ' + error);
      } else {
        Session.set('resetPassword', null);
        Accounts._resetPasswordToken = null;
        Router.go('memberPage', { _id: Meteor.userId() });
      }
    });
  }
};

Template.login.events({
  'submit form': function(e) {
    e.preventDefault();
    Session.set('errorMessage', null);

    var email = null;
    if(!Session.get('resetPassword')) {
      email = $(e.target).find('[name=email]').val();
    }

    var password = $(e.target).find('[name=password]').val();

    var password2 = null;
    if(Session.get('newUser') || Session.get('resetPassword')) {
      password2 = $(e.target).find('[name=password2]').val();
    }

    if(Session.get('resetPassword')) {
      resetPassword(password, password2);
    } else if(Session.get('newUser')) {
      register(email, password, password2);
    } else {
      login(email, password);
    }
  },

  'click .new-user': function(e) {
    e.preventDefault();
    Session.set('errorMessage', null);
    Session.set('newUser', !Session.get('newUser'));
  },

  'click .password-recovery': function(e) {
    e.preventDefault();
    Session.set('errorMessage', null);
    var email = Template.instance().$('[name=email]').val();
    recoverPassword(email);
  }
});
