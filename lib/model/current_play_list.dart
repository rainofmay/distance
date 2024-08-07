class CurrentPlayList {
  final int id;
  final String thumbnailUrl;
  final String bigTitle;
  final String info;
  final String theme;
  final int numberOfSong;

  CurrentPlayList({required this.id,
    required this.thumbnailUrl,
    required this.bigTitle,
    required this.info,
    required this.theme,
    required this.numberOfSong});

  // 빈 값을 위한 팩토리 생성자
  factory CurrentPlayList.first() {
    return CurrentPlayList(
        id: 1,
        thumbnailUrl: 'assets/images/themes/music/music_sleep.jpg',
        bigTitle: '밤에 들으면 좋을 음악',
        info: 'Piano',
        theme: 'sleep',
        numberOfSong: 7);
  }

  CurrentPlayList copyWith({
    int? id,
    String? thumbnailUrl,
    String? bigTitle,
    String? info,
    String? theme,
    int? numberOfSong,
  }) {
    return CurrentPlayList(
        id: id ?? this.id,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        bigTitle: bigTitle ?? this.bigTitle,
        info: info ?? this.info,
        theme: theme ?? this.theme,
        numberOfSong: numberOfSong ?? this.numberOfSong);
  }
}