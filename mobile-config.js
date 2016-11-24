App.info({
  id: 'com.mxi.mijnmxi',
  name: 'MijnMXI',
  description: 'Voor en door M&I',
  author: 'M&I/Partners',
  email: 'contact@example.com',
  website: 'http://example.com'
});

App.icons({
  'iphone_2x': 'public/icons/apple-touch-icon-120x120.png',
  'iphone_3x': 'public/icons/apple-touch-icon-180x180.png',
  'android_mdpi': 'public/icons/android-chrome-48x48.png',
  'android_hdpi': 'public/icons/android-chrome-72x72.png',
  'android_xhdpi': 'public/icons/android-chrome-96x96.png',
  'android_xxhdpi': 'public/icons/android-chrome-144x144.png',
  'android_xxxhdpi': 'public/icons/android-chrome-192x192.png'
});

App.configurePlugin('phonegap-plugin-push', {
  SENDER_ID: '470168538554'
});
