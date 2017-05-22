// Listen to incoming HTTP requests, can only be used on the server
WebApp.rawConnectHandlers.use(function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    return next();
});

// Temporary to fill userChannels
Meteor.startup(function() {
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
