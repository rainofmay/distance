enum OnlineStatus { online, offline, away, dnd }

extension OnlineStatusExtension on OnlineStatus {
  static OnlineStatus fromString(String value) {
    switch (value) {
      case 'online':
        return OnlineStatus.online;
      case 'offline':
        return OnlineStatus.offline;
      case 'away':
        return OnlineStatus.away;
      case 'dnd':
        return OnlineStatus.dnd;
      default:
        throw Exception('Invalid OnlineStatus value: $value');
    }
  }

  String get stringValue => toString().split('.').last;
}
