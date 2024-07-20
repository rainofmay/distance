class ThemePicture {
  final int id;
  final String thumbnailUrl;
  final String highQualityUrl;
  final bool isPaid;
  final bool isImage;
  final String category;

  ThemePicture({
    required this.thumbnailUrl,
    required this.highQualityUrl,
    required this.id,
    required this.isPaid,
    required this.isImage,
    required this.category,
  });

  factory ThemePicture.fromJson(Map<String, dynamic> json) {
    return ThemePicture(
      id: json['id'],
      thumbnailUrl: json['thumbnail_url'], // JSON 키 이름과 일치하게 수정
      highQualityUrl: json['high_quality_url'], // JSON 키 이름과 일치하게 수정
      isPaid: json['is_paid'], // JSON 키 이름과 일치하게 수정
      isImage: json['is_image'],
      category: json['category'],
    );
  }
  static List<ThemePicture> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ThemePicture.fromJson(json as Map<String, dynamic>)).toList();
  }
}

class ThemeVideo {
  final int id;
  final String thumbnailUrl;
  final String highQualityUrl;
  final bool isPaid;
  final bool isImage;
  final String category;

  ThemeVideo({
    required this.id,
    required this.thumbnailUrl,
    required this.highQualityUrl,
    required this.isPaid,
    required this.isImage,
    required this.category,
  });

  factory ThemeVideo.fromJson(Map<String, dynamic> json) {
    return ThemeVideo(
      id: json['id'],
      thumbnailUrl: json['thumbnail_url'], // JSON 키 이름과 일치하게 수정
      highQualityUrl: json['high_quality_url'], // JSON 키 이름과 일치하게 수정
      isPaid: json['is_paid'], // JSON 키 이름과 일치하게 수정
      isImage: json['is_image'],
      category: json['category'],
    );
  }
  static List<ThemeVideo> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ThemeVideo.fromJson(json as Map<String, dynamic>)).toList();
  }
}
