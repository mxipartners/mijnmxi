// Listen to incoming HTTP requests, can only be used on the server
WebApp.rawConnectHandlers.use(function(req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    return next();
});

// Error helper
this.throwError = function(error, reason, details) {
  var meteorError = new Meteor.Error(error, reason, details);
  throw meteorError;
};
