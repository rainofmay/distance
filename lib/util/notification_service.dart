import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _permissionWithNotification();
    await _initializeNotifications();
  }

  // 플랫폼 권한 요청
  Future<void> _permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  Future<void> _initializeNotifications() async {
    // timezone 초기화
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    AndroidInitializationSettings android = const AndroidInitializationSettings("@mipmap/launcher_icon");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
    await local.initialize(settings);
  }

  Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      DateTime scheduledDate,) async {

    await local.zonedSchedule(
      id, // 0이면 동일한 ID를 사용하여 기존 알림을 덮어씀
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'show_test your_channel_id',
          'Distance',
          channelDescription: 'Test Local notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  // 테스트 알림 보내기
  // Future<void> showTestNotification() async {
  //   NotificationDetails details = const NotificationDetails(
  //     iOS: DarwinNotificationDetails(
  //       presentAlert: true,
  //       presentBadge: true,
  //       presentSound: true,
  //     ),
  //     android: AndroidNotificationDetails(
  //       "1",
  //       "test",
  //       importance: Importance.max,
  //       priority: Priority.high,
  //     ),
  //   );
  //
  //   await local.show(1, "title", "body", details);
  // }
}