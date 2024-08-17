import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/repository/mate/mate_repository.dart';
import 'package:mobile/repository/user/user_repository.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/custom_snackbar.dart';
class MateViewModel extends GetxController {
  // Rx variables for user profile data
  late final UserRepository _userRepository;
  late final MateRepository _mateRepository;

  MateViewModel({required UserRepository userRepository, required MateRepository mateRepository}){
    _userRepository = userRepository;
    _mateRepository = mateRepository;
}
  final UserProvider userProvider = UserProvider();

  late final RxString name = "".obs;
  late final RxString introduction = "".obs;
  late final RxString imageUrl = "".obs;
  late final RxString profileImageUrl = "".obs;
  late final RxString backgroundUrl = "".obs;
  late final RxString musicUrl = "".obs;
  late final Rx<OnlineStatus> isUserOnline = OnlineStatus.offline.obs;
  late final RxString userCurrentActivityEmoji=''.obs ;
  late final RxString userCurrentActivityText =''.obs;
  late final RxBool isWordOpen = false.obs;
  late final RxBool isScheduleOpen = false.obs;

  late final RxBool isPaid = false.obs;
  // Initialize mateProfiles with empty list
  final pendingMateProfiles = <Rx<UserModel>>[].obs;
  final mateProfiles = <Rx<UserModel>>[].obs;
  // Methods for updating profile data are simplified
  final searchingProfiles = <Rx<UserModel>>[].obs;


  final RxString nameError = RxString('');
  final RxString introductionError = RxString('');
  final RxString statusError = RxString('');

  late final RxBool _emojiShowing = false.obs;
  bool get emojiShowing => _emojiShowing.value;
  late final Rx<TextEditingController> _nameController = TextEditingController(text: name.value).obs;
  TextEditingController get nameController => _nameController.value;
  late final Rx<TextEditingController> _introduceController = TextEditingController(text: introduction.value).obs;
  TextEditingController get introduceController => _introduceController.value;
  late final Rx<TextEditingController> _statusController = TextEditingController(text: userCurrentActivityText.value).obs;
  TextEditingController get statusController => _statusController.value;
  late final Rx<TextEditingController> _emojiController = TextEditingController(text: userCurrentActivityEmoji.value).obs;
  TextEditingController get emojiController => _emojiController.value;


  late final Rx<TextEditingController> _emailController = TextEditingController().obs;
  TextEditingController get emailController => _emailController.value;
  late final Rx<ScrollController> _scrollController = ScrollController().obs;
  ScrollController get scrollController => _scrollController.value;

  final Rx<File?> localProfileImage = Rx<File?>(null);

  Future<void> updateProfileImageLocally(File imageFile) async {
    localProfileImage.value = imageFile;
    update();
  }


  /* notification */
  late final RxList<Map<String, String>> _notificationList = <Map<String, String>>[].obs;
  List<Map<String, String>> get notificationList => _notificationList;

  late final RxBool _isExpanded = false.obs;
  bool get isExpanded => _isExpanded.value;
  void toggleExpansion() {
    _isExpanded.value = !_isExpanded.value;
  }

  @override
  onInit() {
    super.onInit();
    updateMyProfile();
    getPendingMates();
    getMyMate();
    loadNotifications();
  }

  @override
  void dispose() {
    _nameController.value.dispose();
    _introduceController.value.dispose();
    _statusController.value.dispose();
    _emojiController.value.dispose();

    _emailController.value.dispose();
    _scrollController.value.dispose();
    super.dispose();
  }

  Future<void> loadNotifications() async {
    try {
      _notificationList.value = await _mateRepository.fetchNotificationList();
    } catch (error) {
      print('Error in ViewModel loading notifications: $error');
      // 에러 처리 (예: 사용자에게 에러 메시지 표시)
    }
  }

  void updateName(String newName) => name.value = newName;

  void updateIntroduction(String newIntroduction) =>
      introduction.value = newIntroduction;

  void updateImageUrl(String newImageUrl) => imageUrl.value = newImageUrl;

  Future<void> updateProfileImageUrl(String newProfileImageUrl) async {
    profileImageUrl.value = newProfileImageUrl;
    localProfileImage.value = null;
    update();
  }

  void updateOnlineStatus(OnlineStatus newStatus) =>
      isUserOnline.value = newStatus;

  void updateCurrentActivityEmoji(String newEmoji) {
    userCurrentActivityEmoji.value = newEmoji;
    emojiController.text = newEmoji;  // emojiController도 업데이트
  }

  void updateCurrentActivityText(String newActivity) =>
      userCurrentActivityText.value = newActivity;

  void updateIsWordOpen(bool isOpen) =>
      isWordOpen.value = isOpen;

  void updateIsScheduleOpen(bool isOpen) =>
      isScheduleOpen.value = isOpen;



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
      mateProfiles.refresh();
    } catch (e) {
      // 에러 처리 (예: 사용자에게 에러 메시지 표시)
      print('Error fetching my mate profiles: $e');
      // 필요에 따라 추가적인 에러 처리 로직을 구현
    }
  }

  void setEmojiShowing(newValue) {
    _emojiShowing.value = newValue;
  }

  void setScheduleOpen(newValue) {
    isScheduleOpen.value = newValue;
  }

  void validateName(String value) {
    if (value.isEmpty) {
      nameError.value = "이름을 입력해 주세요.";
    } else if (value.length > 8) {
      nameError.value = "8자 이내로 입력해 주세요.";
    } else {
      nameError.value = '';
    }
  }

  void validateIntroduction(String value) {
    if (value.length > 15) {
      introductionError.value = "15자 이내로 입력해 주세요.";
    } else {
      introductionError.value = '';
    }
  }

  void validateStatus(String value) {
    if (value.length > 20) {
      statusError.value = "20자 이내로 입력해 주세요.";
    } else {
      statusError.value = '';
    }
  }

  void onSavePressed() async {
    // 모든 필드의 유효성을 다시 한 번 검사
    validateName(_nameController.value.text);
    validateIntroduction(_introduceController.value.text);
    validateStatus(_statusController.value.text);

    // 모든 필드가 유효한 경우에만 저장 진행
    if (nameError.isEmpty && introductionError.isEmpty && statusError.isEmpty) {
      updateName(_nameController.value.text);
      updateIntroduction(_introduceController.value.text);
      onTapCurrentActivity(userCurrentActivityEmoji.value, _statusController.value.text);

      await userProvider.editName(_nameController.value.text);
      await userProvider.editIntroduction(_introduceController.value.text);
      await userProvider.editStatusEmoji(_emojiController.value.text);
      await userProvider.editStatusText(_statusController.value.text);
      await userProvider.updateUserSettings(isWordOpen.value, isScheduleOpen.value);

      Get.back(); // 이전 화면으로 돌아가기
    } else {
      // 유효하지 않은 필드가 있는 경우 사용자에게 알림
      Get.snackbar('오류', '입력 정보를 확인해 주세요.');
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
        isWordOpen.value = myProfile.isWordOpen ?? false;
        isScheduleOpen.value = myProfile.isScheduleOpen ?? false;
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
      loadNotifications();
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
      // Get.snackbar("친구 요청", "거절");
    } catch (e) {
      // 에러 처리
      print('Error accepting mate request: $e');
    }
  }


  Future<void> deleteMate(String mateId) async {
    try {
      await _mateRepository.deleteMate(mateId);
      // 리스트에서 메이트 제거 후 전체 리스트를 새로 할당
      mateProfiles.value = mateProfiles.where((profile) => profile.value.id != mateId).toList();
      // 또는 아래와 같이 할 수 있습니다:
      // mateProfiles.assignAll(mateProfiles.where((profile) => profile.value.id != mateId).toList());
    } catch (e) {
      print('Error deleting mate: $e');
    }
  }

  // 이메일 유효성 검사를 위한 정규표현식
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> sendMateRequestByEmail(String email) async {
    // 빈 문자열 체크
    if (email.isEmpty) {
      CustomSnackbar.show(title: '오류', message: '이메일을 입력해주세요.');
      return;
    }

    // 이메일 형식 검사
    if (!emailRegex.hasMatch(email)) {
      CustomSnackbar.show(title: '오류', message: '올바른 이메일 형식이 아닙니다.');
      return;
    }

    // 이메일 유효성 검사를 통과한 경우에만 요청 전송
    try {
      await _mateRepository.sendMateRequestByEmail(email);
      loadNotifications();
    } catch (e) {
      CustomSnackbar.show(title: '오류', message: '메이트 요청 중 오류가 발생했습니다.');
      print('Error in sendMateRequestByEmail: $e');
    }
  }


  Future<void> searchMateByEmail(String email) async {
    final users = await _mateRepository.searchMatesByEmail(email);
    //미완
  }

  void logout() async{
    final scheduleViewModel = Get.find<ScheduleViewModel>();
    // 기본 사용자 정보 초기화
    name.value = "";
    introduction.value = "";
    imageUrl.value = "";
    profileImageUrl.value = "";
    backgroundUrl.value = "";
    musicUrl.value = "";
    userCurrentActivityEmoji.value = '';
    userCurrentActivityText.value = '';
    isScheduleOpen.value = false;
    isPaid.value = false;

    // 리스트 초기화
    pendingMateProfiles.clear();
    mateProfiles.clear();
    searchingProfiles.clear();

    // TextEditingController 초기화
    _emailController.value.clear();

    // 추가적인 초기화가 필요한 경우 여기에 작성
    await scheduleViewModel.loadAllSchedules();
    // 변경 사항 알림
    update();

    // 로그아웃 성공 메시지 표시 (선택사항)
    // Get.snackbar("로그아웃", "성공적으로 로그아웃되었습니다.");

    // 로그인 페이지로 이동 (필요한 경우)
    // Get.offAll(() => LoginPage());
  }

}
