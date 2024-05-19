
class UserProfile {
  final String name;
  final String imageUrl;
  final bool onlineStatus;
  final String currentActivity;
  final String profileImageUrl;

  UserProfile({
    required this.profileImageUrl,
    required this.name,
    required this.imageUrl,
    required this.onlineStatus,
    required this.currentActivity,
  });
}
