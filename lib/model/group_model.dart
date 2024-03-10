class Group {
  int groupId;
  User user;
  String groupBackgroundURL;
  String groupAudioURL;
  DateTime groupStudyTime;
  List<String> groupNotices;

  Group({
    required this.groupId,
    required this.user,
    required this.groupBackgroundURL,
    required this.groupAudioURL,
    required this.groupStudyTime,
    required this.groupNotices,
  });
}

class User {
  //1. 유저 이름
  String userName;
  //2. 유저 사진
  String userProfilePictureUrl;
  //3. 유저 주간 Group 공부시간
  int studyTime;
  //4.
  User({required this.userName, required this.userProfilePictureUrl, required this.studyTime});
  // 사용자 클래스 추가해야 함.
}
