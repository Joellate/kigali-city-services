import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAb6sqGh4SANZMJRz80yvuT2J2KwCAx72c',
    appId: '1:490164165846:web:2b9d574707457f12807d77',
    messagingSenderId: '490164165846',
    projectId: 'kigali-city-services-877ab',
    authDomain: 'kigali-city-services-877ab.firebaseapp.com',
    databaseURL: 'https://kigali-city-services-877ab.firebaseio.com',
    storageBucket: 'kigali-city-services-877ab.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAo2wt8gVstS4mCMOv_Gm_DCCuF1h0z--E',
    appId: '1:490164165846:android:ba7957978f1248ce807d77',
    messagingSenderId: '490164165846',
    projectId: 'kigali-city-services-877ab',
    databaseURL: 'https://kigali-city-services-877ab.firebaseio.com',
    storageBucket: 'kigali-city-services-877ab.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBr2YF1cs10g5gZUOslcEzCOoeo7EH4--4',
    appId: '1:490164165846:ios:4960846fd329d9c1807d77',
    messagingSenderId: '490164165846',
    projectId: 'kigali-city-services-877ab',
    databaseURL: 'https://kigali-city-services-877ab.firebaseio.com',
    storageBucket: 'kigali-city-services-877ab.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAb6sqGh4SANZMJRz80yvuT2J2KwCAx72c',
    appId: '1:490164165846:web:2b9d574707457f12807d77',
    messagingSenderId: '490164165846',
    projectId: 'kigali-city-services-877ab',
    databaseURL: 'https://kigali-city-services-877ab.firebaseio.com',
    storageBucket: 'kigali-city-services-877ab.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAb6sqGh4SANZMJRz80yvuT2J2KwCAx72c',
    appId: '1:490164165846:web:2b9d574707457f12807d77',
    messagingSenderId: '490164165846',
    projectId: 'kigali-city-services-877ab',
    databaseURL: 'https://kigali-city-services-877ab.firebaseio.com',
    storageBucket: 'kigali-city-services-877ab.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyAb6sqGh4SANZMJRz80yvuT2J2KwCAx72c',
    appId: '1:490164165846:web:2b9d574707457f12807d77',
    messagingSenderId: '490164165846',
    projectId: 'kigali-city-services-877ab',
    databaseURL: 'https://kigali-city-services-877ab.firebaseio.com',
    storageBucket: 'kigali-city-services-877ab.firebasestorage.app',
  );
}
