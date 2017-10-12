// Listen to incoming HTTP requests, can only be used on the server
WebApp.rawConnectHandlers.use(function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    return next();
});

// Temporary to fill userChannels
Meteor.startup(function() {
  process.env.MAIL_URL = "smtp://localhost:25";

  Accounts.emailTemplates.siteName = "Mijn M&I";
  Accounts.emailTemplates.from = "Mijn M&I <noreply@mxi.nl>";

  Accounts.urls.resetPassword = function(token) {
    return 'https://mijn.mxi.nl/#/reset-password/' + token;
  }

  Accounts.emailTemplates.resetPassword = {
      subject() {
          return "Wachtwoordherstel";
      },
      text( user, url ) {
          emailBody = `Klik op onderstaande link om je wachtwoord te resetten.\n` + url;
          return emailBody;
      }
  };

  Meteor.users.find({}).forEach(function(user) {
    Projects.find({ members: user._id }).forEach(function(project) {
      var count = 0;
      UserChannels.find({ userId: user._id, projectId: project._id }).forEach(function(userChannel) {
        count++;
      });
      if(count === 0) {
        var userChannelId = UserChannels.insert({ userId: user._id, projectId: project._id, lastSeen: new Date(), lastMessageTimestamp: new Date(2000, 0, 1, 0, 0, 0) });
      } else if(count > 1) {
        console.error("Already more than 1 user channel for user: " + user._id + " and project: " + project._id);
      }
    });
  });
});
