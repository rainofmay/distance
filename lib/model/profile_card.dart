//
// import 'package:mobile/view_model/mate/mate_view_model.dart';

class UserProfile {
  late final String name;
  late final String introduction;
  late final String imageUrl;
  // late final OnlineStatus onlineStatus;
  late final String currentActivity;
  late final String profileImageUrl;

  UserProfile({
    required this.name,
    required this.introduction,
    required this.imageUrl,
    // required this.onlineStatus,
    required this.currentActivity,
    required this.profileImageUrl,
  });
}
