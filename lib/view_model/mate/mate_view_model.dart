import 'package:get/get.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/repository/mate/mate_repository.dart';
import 'package:mobile/repository/user/user_repository.dart';
class MateViewModel extends GetxController {
  // Rx variables for user profile data
  late final UserRepository _userRepository;
  late final MateRepository _mateRepository;

  MateViewModel({required UserRepository userRepository, required MateRepository mateRepository}){
    _userRepository = userRepository;
    _mateRepository = mateRepository;
}


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
  final pendingMateProfiles = <Rx<UserModel>>[].obs;
  final mateProfiles = <Rx<UserModel>>[].obs;
  // Methods for updating profile data are simplified
  final searchingProfiles = <Rx<UserModel>>[].obs;

  void updateName(String newName) => name.value = newName;

  void updateIntroduction(String newIntroduction) =>
      introduction.value = newIntroduction;

  void updateImageUrl(String newImageUrl) => imageUrl.value = newImageUrl;

  Future<void> updateProfileImageUrl(String newProfileImageUrl) async =>
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
    getPendingMates();
    getMyMate();
  }


  Future<void> getPendingMates() async {
    try {
      final pendingProfiles = await _mateRepository.fetchPendingRequests();
      pendingMateProfiles.value = pendingProfiles.map((user) => Rx(user)).toList(); // Rx로 감싸기
    } catch (e) {
      print('Error fetching pending mate profiles: $e');
    }

  }

  Future<void> getMyMate() async {
    try {
      final myMates = await _mateRepository.fetchMyMates();
      mateProfiles.value = myMates.map((mate) => Rx(mate)).toList(); // mateProfiles를 업데이트
      print("[Get myMates] $myMates");

    } catch (e) {
      // 에러 처리 (예: 사용자에게 에러 메시지 표시)
      print('Error fetching my mate profiles: $e');
      // 필요에 따라 추가적인 에러 처리 로직을 구현
    }
  }

  // 상태 업데이트 함수
  Future<void> updateMyProfile() async {
    super.onInit(); // 먼저 super.onInit() 호출

    try {
      final myProfile = await _userRepository.fetchMyProfile();
      if (myProfile != null) { // null 확인
        profileImageUrl.value = myProfile.profileUrl ?? '';
        name.value = myProfile.name ?? ''; // null 처리
        introduction.value = myProfile.introduction ?? ''; // null 처리
        imageUrl.value = myProfile.profileUrl ?? ''; // null 처리
        backgroundUrl.value = myProfile.backgroundUrl ?? ''; // null 처리
        musicUrl.value = myProfile.musicUrl ?? ''; // null 처리
        isPaid.value = myProfile.isPaid ?? false;
        userCurrentActivityEmoji.value = myProfile.statusEmoji ?? ''; // null 처리
        userCurrentActivityText.value = myProfile.statusText ?? ''; // null 처리
        update();
      }
    } catch (e) {
      // 에러 처리 (예: 사용자에게 에러 메시지 표시)
      print('Error fetching user profile: $e');
    }
  }
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
  /*친구 요청 */
  void acceptMate(String requestId) async {
    try {
      await _mateRepository.handleAccept(requestId);
      pendingMateProfiles.removeWhere((mate) => mate.value.id == requestId); // 요청 제거
      pendingMateProfiles.refresh(); // 변경 사항 알림
      Get.snackbar("친구 요청", "승인 완료!");
    } catch (e) {
      // 에러 처리
      print('Error accepting mate request: $e');
    }
  }

  void rejectMate(String requestId) async {
    try {
      await _mateRepository.handleReject(requestId);
      pendingMateProfiles.removeWhere((mate) => mate.value.id == requestId); // 요청 제거
      pendingMateProfiles.refresh(); // 변경 사항 알림
      Get.snackbar("친구 요청", "거절");
    } catch (e) {
      // 에러 처리
      print('Error accepting mate request: $e');
    }
  }

  Future<void> sendMateRequestByEmail(String email) async{
    await _mateRepository.sendMateRequestByEmail(email);
  }

  Future<void> searchMateByEmail(String email) async {
    final users = await _mateRepository.searchMatesByEmail(email);
    //미완
  }

}