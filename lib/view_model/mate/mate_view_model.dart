import 'package:get/get.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/model/profile_card.dart';
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/repository/user/user_repository.dart';
class MateViewModel extends GetxController {
  // Rx variables for user profile data
  final UserRepository _repository;
  MateViewModel({required UserRepository repository})
      : _repository = repository;

  late final RxString name = "".obs;
  late final RxString introduction = "".obs;
  late final RxString imageUrl = "".obs;
  late final RxString profileImageUrl = "".obs;
  late final RxString backgroundUrl = "".obs;
  late final RxString musicUrl = "".obs;
  late final Rx<OnlineStatus> isUserOnline = OnlineStatus.offline.obs;
  late final RxString userCurrentActivityEmoji=''.obs ;
  late final RxString userCurrentActivityText =''.obs;
  late final RxBool isPaid = false.obs;
  // Initialize mateProfiles with empty list
  final mateProfiles = <UserProfile>[].obs;

  // Methods for updating profile data are simplified
  void updateName(String newName) => name.value = newName;

  void updateIntroduction(String newIntroduction) =>
      introduction.value = newIntroduction;

  void updateImageUrl(String newImageUrl) => imageUrl.value = newImageUrl;

  void updateProfileImageUrl(String newProfileImageUrl) =>
      profileImageUrl.value = newProfileImageUrl;

  void updateOnlineStatus(OnlineStatus newStatus) =>
      isUserOnline.value = newStatus;

  void updateCurrentActivityEmoji(String newActivity) =>
      userCurrentActivityEmoji.value = newActivity;

  void updateCurrentActivityText(String newActivity) =>
      userCurrentActivityText.value = newActivity;

  @override
  onInit() {
    super.onInit();
    updateMyProfile();
  }

  Future<void> updateMyProfile() async {
    super.onInit(); // 먼저 super.onInit() 호출

    try {
      final myProfile = await _repository.fetchMyProfile();
      if (myProfile != null) { // null 확인
        name.value = myProfile.name ?? ''; // null 처리
        introduction.value = myProfile.introduction ?? ''; // null 처리
        imageUrl.value = myProfile.profileUrl ?? ''; // null 처리
        backgroundUrl.value = myProfile.backgroundUrl ?? ''; // null 처리
        musicUrl.value = myProfile.musicUrl ?? ''; // null 처리
        isPaid.value = myProfile.isPaid ?? false;
        userCurrentActivityEmoji.value = myProfile.statusEmoji ?? ''; // null 처리
        userCurrentActivityText.value = myProfile.statusText ?? ''; // null 처리
      }
    } catch (e) {
      // 에러 처리 (예: 사용자에게 에러 메시지 표시)
      print('Error fetching user profile: $e');
    }
  }

  // onTap 함수 구현
  void onTapOnlineStatus(OnlineStatus status) {
    switch (status) {
      case OnlineStatus.online:
        updateOnlineStatus(OnlineStatus.online);
        print("online");
        break;
      case OnlineStatus.away:
        updateOnlineStatus(OnlineStatus.away);
        print("away");
        break;
      case OnlineStatus.dnd:
        updateOnlineStatus(OnlineStatus.dnd);
        print("dnd");
        break;
      case OnlineStatus.offline:
        updateOnlineStatus(OnlineStatus.offline);
        print("offline");
        break;
    }
  }

  void onTapCurrentActivity(String emoji, String text) {
    updateCurrentActivityEmoji(emoji);
    updateCurrentActivityText(text);
    // showBottomSheet 또는 다른 UI 요소를 통해 현재 활동 변경 UI를 표시
  }
}
