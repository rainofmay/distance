
import 'package:mobile/model/online_status.dart';

class UserProfile {
  late final String name;
  late final String introduction;
  late final String imageUrl;
  late final OnlineStatus onlineStatus;
  late final String currentActivity;
  late final String profileImageUrl;
  late final DateTime? createdAt;
  late final DateTime? updatedAt;
  UserProfile({
    required this.name,
    required this.introduction,
    required this.imageUrl,
    required this.onlineStatus,
    required this.currentActivity,
    required this.profileImageUrl,
    this.createdAt,
    this.updatedAt
  });
}
