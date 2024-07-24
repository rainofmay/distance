class CurrentPlayList {
  final int id;
  final String thumbnailUrl;
  final String bigTitle;
  final String theme;
  final int numberOfSong;

  CurrentPlayList({required this.id, required this.thumbnailUrl, required this.bigTitle, required this.theme, required this.numberOfSong});

  // 빈 값을 위한 팩토리 생성자
  factory CurrentPlayList.empty() {
    return CurrentPlayList(
        id: 0,
        thumbnailUrl: '',
        bigTitle: '',
        theme: '',
        numberOfSong: 0,
    );
  }

  CurrentPlayList copyWith({
    int? id,
    String? thumbnailUrl,
    String? bigTitle,
    String? theme,
    int? numberOfSong,
  }) {
    return CurrentPlayList(
        id : id ?? this.id,
        bigTitle: bigTitle ?? this.bigTitle,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        theme: theme ?? this.theme,
        numberOfSong: numberOfSong ?? this.numberOfSong);
  }

  factory CurrentPlayList.fromJson(Map<String, dynamic> json) {
    return CurrentPlayList(
      id : json['id'],
      thumbnailUrl: json['thumbnail_url'],
      bigTitle: json['big_title'],
      theme: json['theme'],
      numberOfSong: json['number_of_song'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'thumbnail_url': thumbnailUrl,
    'big_title' : bigTitle,
    'theme': theme,
    'number_of_song' : numberOfSong,
  };
}