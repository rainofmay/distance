import 'dart:async';
import 'dart:ui';

import 'package:mobile/model/online_status.dart';
import 'package:mobile/provider/user/user_provider.dart';

class OnlineStatusManager {
  OnlineStatus _currentStatus = OnlineStatus.online;
  DateTime? _lastActiveTime;
  Timer? _backgroundTimer;
  bool _hasUpdatedToAway = false;
  bool _hasUpdatedToOffline = false;
  UserProvider userProvider = UserProvider();

  void handleOnlineLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.hidden|| state == AppLifecycleState.detached) {
      _lastActiveTime = DateTime.now();
      _startBackgroundTimer();
      print("[BackgroundObserver]: ON");
    } else if (state == AppLifecycleState.resumed) {
      _backgroundTimer?.cancel();
      _resetStatus();
      print("[BackgroundObserver]: OFF");
    }
  }

  void _startBackgroundTimer() {
    _backgroundTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updateStatusBasedOnInactiveTime();
    });
  }

  void _updateStatusBasedOnInactiveTime() {
    if (_lastActiveTime == null) return;

    final inactiveDuration = DateTime.now().difference(_lastActiveTime!);

    if (inactiveDuration.inMinutes >= 2 && !_hasUpdatedToOffline) {
      updateOnlineStatus(OnlineStatus.offline);
      print("[BackgroundObserver] State: offline");
      _hasUpdatedToOffline = true;
    } else if (inactiveDuration.inMinutes >= 1 && !_hasUpdatedToAway && !_hasUpdatedToOffline) {
      updateOnlineStatus(OnlineStatus.away);
      print("[BackgroundObserver] State: away");
      _hasUpdatedToAway = true;
    }
  }

  void _resetStatus() {
    if (_currentStatus != OnlineStatus.online) {
      updateOnlineStatus(OnlineStatus.online);
      print("[BackgroundObserver]: online");
    }
    _hasUpdatedToAway = false;
    _hasUpdatedToOffline = false;
  }

  void updateOnlineStatus(OnlineStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      // 여기서 Supabase API를 호출하여 상태를 업데이트합니다.
      userProvider.editStatusOnline(status);
    }
  }
}