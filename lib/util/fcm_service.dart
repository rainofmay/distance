import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/widgets/custom_snackbar.dart';

class FcmService {
  final supabase = Supabase.instance.client;

  void initialize() {
    supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        await FirebaseMessaging.instance.requestPermission(
          badge: true,
          alert: true,
          sound: true,
        );

        await FirebaseMessaging.instance.getAPNSToken();
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          _setFcmToken(fcmToken);
        }
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await _setFcmToken(fcmToken);
    });

    //Foreground
    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;

      if (notification != null) {
        CustomSnackbar.show(title: '${notification.title}', message: '${notification.body}');
      }
    });
  }

  Future<void> _setFcmToken(String fcmToken) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase
          .from('profiles')
          .upsert({'id': userId, 'fcm_token': fcmToken});
    }
  }
}