import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mobile/model/current_play_list.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/music/myroom_music_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class MyRoomMusicRepository {
  late final MyRoomMusicProvider _myRoomMusicProvider;

  MyRoomMusicRepository({required MyRoomMusicProvider myRoomMusicProvider})
      : _myRoomMusicProvider = myRoomMusicProvider;

  final List playListTheme = [
    CurrentPlayList(
        id: 1,
        thumbnailUrl: 'assets/images/themes/music/music_sleep.jpg',
        bigTitle: '밤에 들으면 좋을 음악',
        info: 'Piano',
        theme: 'sleep',
        numberOfSong: 3),
    CurrentPlayList(
        id: 2,
        thumbnailUrl: 'assets/images/themes/music/music_consolation.jpg',
        bigTitle: '위로가 되는 음악',
        info : 'Piano',
        theme: 'consolation',
        numberOfSong: 9),
    CurrentPlayList(
        id: 3,
        thumbnailUrl: 'assets/images/themes/music/music_morning.jpg',
        bigTitle: '하루를 시작하는 음악',
        info : 'Acoustic, piano',
        theme: 'morning',
        numberOfSong: 7),
    CurrentPlayList(
        id: 4,
        thumbnailUrl: 'assets/images/themes/music/music_evening.jpg',
        bigTitle: '퇴근길 해질무렵 듣는 음악',
        info : 'Acoustic, piano',
        theme: 'evening',
        numberOfSong: 7),
    CurrentPlayList(
        id: 5,
        thumbnailUrl: 'assets/images/themes/music/music_thought.jpg',
        bigTitle: '생각 많아질 때 듣는 음악',
        info : 'Piano',
        theme: 'thought',
        numberOfSong: 3)
  ];

  /* Get */
  Future<List<MusicInfo>> fetchThemeMusic(String theme) async {
    try {
      final response = await _myRoomMusicProvider.getThemeMusic(theme);
      return response.map((item) => MusicInfo.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetchThemeMusic: $e');
    }
  }

  Future<String> downloadMusicFromUrl(String url) async {
    try {
      final fileName = _getFileNameFromUrl(url);
      final dir = await _getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        // 파일이 이미 존재하면 캐시된 파일 경로 반환
        return file.path;
      }

      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      throw Exception('Error downloading music: $e');
    }
  }

  Future<Directory> _getApplicationDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  String _getFileNameFromUrl(String url) {
    // URL에서 고유한 파일 이름 생성
    final hash = md5.convert(utf8.encode(url)).toString();
    return 'music_$hash.mp3';
  }

  Future<String?> loadCurrentPlayListIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final currentPlayListIndex = prefs.getString('currentTheme');

    return currentPlayListIndex;
  }

  /* Create */
  Future<void> saveCurrentPlayListIndex(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPlayListTheme = theme;
    print("[currentPlayListIndex Save] : $currentPlayListTheme");
    await prefs.setString('currentTheme', currentPlayListTheme);
  }
}
