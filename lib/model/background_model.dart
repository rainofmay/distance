class ThemePicture {
  final int id;
  final String thumbnailUrl;
  final String highQualityUrl;
  final bool isPaid;

  ThemePicture({
    required this.thumbnailUrl,
    required this.highQualityUrl,
    required this.id,
    required this.isPaid,
  });
}

class ThemeVideo {
  final int id;
  final String thumbnailUrl;
  final String highQualityUrl;
  final bool isPaid;

  ThemeVideo({
    required this.id,
    required this.thumbnailUrl,
    required this.highQualityUrl,
    required this.isPaid,
  });
}
