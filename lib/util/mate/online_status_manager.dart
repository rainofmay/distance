import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/provider/user/user_provider.dart';

class OnlineStatusManager {
  static OnlineStatus _currentStatus = OnlineStatus.online;
  static DateTime? _lastActiveTime;
  static final UserProvider _userProvider = UserProvider();

  static Future<void> initializeBackgroundFetch() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
      ),
      _onBackgroundFetch,
    );

    BackgroundFetch.registerHeadlessTask(_onBackgroundFetchHeadlessTask);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      print("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }
    print("[BackgroundFetch] Headless event received: $taskId");
    await _updateStatusBasedOnInactiveTime();
    BackgroundFetch.finish(taskId);
  }

  static Future<void> _onBackgroundFetch(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");
    await _updateStatusBasedOnInactiveTime();
    BackgroundFetch.finish(taskId);
  }

  static Future<void> _updateStatusBasedOnInactiveTime() async {
    final prefs = await SharedPreferences.getInstance();
    _lastActiveTime = DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt('lastActiveTime') ?? DateTime.now().millisecondsSinceEpoch
    );

    final inactiveDuration = DateTime.now().difference(_lastActiveTime!);

    if (inactiveDuration.inMinutes >= 2 && _currentStatus != OnlineStatus.offline) {
      await _updateOnlineStatus(OnlineStatus.offline);
      print("[BackgroundObserver] State: offline");
    } else if (inactiveDuration.inMinutes >= 1 && _currentStatus != OnlineStatus.away) {
      await _updateOnlineStatus(OnlineStatus.away);
      print("[BackgroundObserver] State: away");
    }
  }

  static Future<void> _updateOnlineStatus(OnlineStatus status) async {
    if (_currentStatus != status) {
      _currentStatus = status;
      await _userProvider.editStatusOnline(status);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentStatus', status.toString());
    }
  }

  static void handleOnlineLifecycleState(AppLifecycleState state) async {
    final prefs = await SharedPreferences.getInstance();
    if (state == AppLifecycleState.paused) {
      await prefs.setInt('lastActiveTime', DateTime.now().millisecondsSinceEpoch);
      print("[BackgroundObserver]: ON");
    } else if (state == AppLifecycleState.resumed) {
      await _resetStatus();
      print("[BackgroundObserver]: OFF");
    }
  }

  static Future<void> _resetStatus() async {
    if (_currentStatus != OnlineStatus.online) {
      await _updateOnlineStatus(OnlineStatus.online);
      print("[BackgroundObserver]: online");
    }
  }
}