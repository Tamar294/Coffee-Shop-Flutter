import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const  FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkV8u4KV6NDf9u9i7AIa5PXpvv_5hQa10',
    appId: '1:402213861032:android:2835bc1b75eb0befe7749d',
    projectId: 'coffeeshop-5bfda',
    messagingSenderId: '402213861032',
    storageBucket: 'coffeeshop-5bfda.appspot.com'
  );
}
