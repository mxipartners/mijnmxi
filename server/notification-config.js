Push.Configure({
  //apn: {
  //  certData: Assets.getText('apnDevCert.pem'),
  //  keyData: Assets.getText('apnDevKey.pem'),
  //  passphrase: 'xxxxxxxxx',
  //  production: true,
    //gateway: 'gateway.push.apple.com',
  //},
  gcm: {
    apiKey: 'AIzaSyA0XAhhMwxCv5VFuUMYiasoBk012GeJSvg',
    projectNumber: 470168538554
  }
  // production: true,
  // 'sound' true,
  // 'badge' true,
  // 'alert' true,
  // 'vibrate' true,
  // 'sendInterval': 15000, Configurable interval between sending
  // 'sendBatchSize': 1, Configurable number of notifications to send per batch
  // 'keepNotifications': false,
//
});


Push.allow({
  send: function(userId, notification) {
    // Allow all users to send to everybody - For test only!
    return true;
  }
});

Meteor.methods({
  'serverNotification'(title, text) {
    Push.send({
      title,
      text,
      from: 'server',
      badge: 1,
      query: {}
    });
  }
});
