import 'package:flutter/cupertino.dart';
import '../common/const/colors.dart';

class MusicInfo {
  final int id;
  final String musicName;
  final String theme;
  final String audioURL;
  final bool isLiked;

  MusicInfo(
      {required this.id,
      required this.musicName,
        required this.theme,
      required this.audioURL,
      required this.isLiked});

  MusicInfo copyWith({
    int? id,
    String? musicName,
    String? theme,
    String? audioURL,
    bool? isLiked,
  }) {
    return MusicInfo(
      id: id ?? this.id,
      musicName: musicName ?? this.musicName,
      theme: theme ?? this.theme,
      audioURL: audioURL ?? this.audioURL,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory MusicInfo.fromJson(Map<String, dynamic> json) {
    return MusicInfo(
      id: json['id'],
      musicName: json['music_name'],
      theme: json['theme'],
      audioURL: json['audio_url'],
      isLiked: json['is_liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'music_name': musicName,
    'theme' : theme,
    'audio_url': audioURL,
    'is_liked': isLiked,
  };
}
