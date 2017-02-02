App.accessRule('*');

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

App.launchScreens({
  'iphone_2x': 'public/splash/iphone - 2x - 640 bij 960.png',
  'iphone5': 'public/splash/iphone5 - 640 bij 1136.png',
  'iphone6': 'public/splash/iphone6 - 750 bij 1334.png',
  'iphone6p_portrait': 'public/splash/iphone6p - portrait - 1242 bij 2208.png',
  'iphone6p_landscape': 'public/splash/iphone6p - landscape - 2208 bij 1242.png',
  'ipad_portrait': 'public/splash/ipad - portrait - 768 bij 1024.png',
  'ipad_portrait_2x': 'public/splash/ipad - portrait - 2x - 1536 bij 2048.png',
  'ipad_landscape': 'public/splash/ipad - landscape - 1024 bij 768.png',
  'ipad_landscape_2x': 'public/splash/ipad - landscape - 2x - 2048 bij 1536.png',
  'android_mdpi_portrait': 'public/splash/android - mdpi - 320 bij 470.9.png',
  'android_mdpi_landscape': 'public/splash/android - mdpi - 470 bij 320.9.png',
  'android_hdpi_portrait': 'public/splash/android - hdpi - 480 bij 640.9.png',
  'android_hdpi_landscape': 'public/splash/android - hdpi - 640 bij 480.9.png',
  'android_xhdpi_portrait': 'public/splash/android - xhdpi - 720 bij 960.9.png',
  'android_xhdpi_landscape': 'public/splash/android - xhdpi - 960 bij 720.9.png',
  'android_xxhdpi_landscape': 'public/splash/android - xxhdpi - 1080 bij 1440.9.png',
  'android_xxhdpi_landscape': 'public/splash/android - xxhdpi - 1440 bij 1080.9.png'
});

App.configurePlugin('phonegap-plugin-push', {
  SENDER_ID: '470168538554'
});

App.setPreference("android-targetSdkVersion", "23");
