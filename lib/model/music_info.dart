import 'package:flutter/cupertino.dart';

import '../common/const/colors.dart';

class MusicInfo {
  final int id;
  final String kindOfMusic;
  final dynamic musicIcon;
  final String audioURL;
  final bool isLiked;

  MusicInfo(
      {required this.id,
      required this.kindOfMusic,
      this.musicIcon,
      required this.audioURL,
      required this.isLiked});

  MusicInfo copyWith({
    int? id,
    String? kindOfMusic,
    dynamic musicIcon,
    String? audioURL,
    bool? isLiked,
  }) {
    return MusicInfo(
      id: id ?? this.id,
      kindOfMusic: kindOfMusic ?? this.kindOfMusic,
      musicIcon: musicIcon ?? this.musicIcon,
      audioURL: audioURL ?? this.audioURL,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory MusicInfo.fromJson(Map<String, dynamic> json) {
    return MusicInfo(
      id: json['id'],
      kindOfMusic: json['kindOfMusic'],
      // musicIcon은 JSON에서 직접 생성할 수 없으므로 null로 설정
      musicIcon : Icon(CupertinoIcons.moon_stars, size: 18, color: LIGHT_WHITE),
      audioURL: json['audioURL'],
      isLiked: json['isLiked'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'kindOfMusic': kindOfMusic,
    'audioURL': audioURL,
    'isLiked': isLiked,
  };


}
