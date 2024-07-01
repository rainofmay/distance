class UserModel {
  int? id;
  String? profileUrl;
  String? name;
  String email;
  String backgroundUrl;
  String musicUrl;
  bool isPaid;
  String statusEmoji;
  String statusText;

  UserModel({
    this.id,
    this.profileUrl,
    this.name,
    required this.email,
    this.backgroundUrl = '', // 기본값 설정
    this.musicUrl = '', // 기본값 설정
    this.isPaid = false, // 기본값 설정
    this.statusEmoji = '', // 기본값 설정
    this.statusText = '', // 기본값 설정
  });

  // UserModel 객체를 데이터베이스에 저장하기 위해 필요한 형식으로 변환하는 역할
  Map<String, dynamic> toMap() {
    return {
      'profile_url': profileUrl,
      'name': name,
      'email': email,
      'background_url': backgroundUrl,
      'music_url': musicUrl,
      'is_paid': isPaid,
      'status_emoji': statusEmoji,
      'status_text': statusText,
    };
  }

  // 데이터베이스로부터 데이터를 읽어와 UserModel 객체로 변환하는 역할
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      profileUrl: json['profile_url'],
      name: json['name'],
      email: json['email'],
      backgroundUrl: json['background_url'] ?? '', // null 처리
      musicUrl: json['music_url'] ?? '', // null 처리
      isPaid: json['is_paid'] ?? false, // null 처리
      statusEmoji: json['status_emoji'] ?? '', // null 처리
      statusText: json['status_text'] ?? '', // null 처리
    );
  }
}
