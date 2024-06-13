class UserModel {
  int? id;
  String? profileUrl;
  String? name;
  String email;
  String uid;

  UserModel({
    this.id,
    this.profileUrl,
    this.name,
    required this.email,
    required this.uid,
  });


// UserModel 객체를 데이터베이스에 저장하기 위해 필요한 형식으로 변환하는 역할
  Map<String, dynamic> toMap() {
    // supabase data column명을 기재
    return {
      'profile_url': profileUrl,
      'name': name,
      'email': email,
      'uid': uid
    };
  }


// 데이터베이스로부터 데이터를 읽어와 UserModel 객체로 변환하는 역할
  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'],
      profileUrl: json['profile_url'],
      name: json['name'],
      email: json['email'],
      uid: json['uid'],
    );
  }
}
