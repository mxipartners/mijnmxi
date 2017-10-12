Push.debug = true;

Push.Configure({
  gcm: {
    apiKey: 'AIzaSyA0XAhhMwxCv5VFuUMYiasoBk012GeJSvg',
    projectNumber: 470168538554
  },
  apn: {
    certData: Assets.getText('meteorApp-cert-prod.pem'),
    keyData: Assets.getText('meteorApp-key-prod.pem'),
    passphrase: 'Eric8990',
    production: false,
    gateway: 'gateway.sandbox.push.apple.com',
  },
  ios: {
    alert: true,
    badge: true,
    sound: true
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
