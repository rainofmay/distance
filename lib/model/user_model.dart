
import 'online_status.dart';

class UserModel {
  String? id;
  String? profileUrl;
  String? name;
  String? introduction;
  String email;
  String uid;
  OnlineStatus onlineStatus;
  String backgroundUrl;
  String musicUrl;
  bool isPaid;
  String statusEmoji;
  String statusText;
  bool isWordOpen;
  bool isScheduleOpen;
  String schedulePush;

  UserModel({
    this.id,
    this.profileUrl,
    this.name,
    this.introduction,
    required this.email,
    required this.uid,
    this.onlineStatus = OnlineStatus.online,
    this.backgroundUrl = '', // 기본값 설정
    this.musicUrl = '', // 기본값 설정
    this.isPaid = false, // 기본값 설정
    this.statusEmoji = '', // 기본값 설정
    this.statusText = '', // 기본값 설정
    this.isWordOpen = false,
    this.isScheduleOpen = false,
    this.schedulePush = '5분 전'
  });

  // UserModel 객체를 데이터베이스에 저장하기 위해 필요한 형식으로 변환하는 역할
  Map<String, dynamic> toMap() {
    return {
      'profile_url': profileUrl,
      'nickname': name,
      'introduction' : introduction,
      'email': email,
      'uid': uid,
      'online_status' : onlineStatus.stringValue,
      'background_url': backgroundUrl,
      'music_url': musicUrl,
      'is_paid': isPaid,
      'status_emoji': statusEmoji,
      'status_text': statusText,
      'is_word_open': isWordOpen,
      'is_schedule_open': isScheduleOpen,
      'schedule_push' : schedulePush,
    };
  }

  // 데이터베이스로부터 데이터를 읽어와 UserModel 객체로 변환하는 역할
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(), // null일 경우 빈 문자열로 변환
      profileUrl: json['profile_url'] ?? 'https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640', // null일 경우 빈 문자열로 설정
      name: json['nickname'] ?? '닉네임',
      introduction: json['introduction'] ?? '',
      email: json['email'] ?? '', // null일 경우 빈 문자열로 설정
      uid: json['uid'] ?? '',
      onlineStatus: OnlineStatusExtension.fromString(json['online_status'] ?? 'online'), // null 또는 알 수 없는 값일 경우 offline으로 설정
      backgroundUrl: json['background_url'] ?? '',
      musicUrl: json['music_url'] ?? '',
      isPaid: json['is_paid'] ?? false,
      statusEmoji: json['status_emoji'] ?? '',
      statusText: json['status_text'] ?? '',
      isWordOpen : json['is_word_open'] ?? false,
      isScheduleOpen : json['is_schedule_open'] ?? false,
      schedulePush: json['schedule_push'] ?? '',
    );
  }


  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

}
