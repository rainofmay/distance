import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mobile/model/current_play_list.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/music/myroom_music_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MyRoomMusicRepository {
  late final MyRoomMusicProvider _myRoomMusicProvider;

  MyRoomMusicRepository({required MyRoomMusicProvider myRoomMusicProvider})
      : _myRoomMusicProvider = myRoomMusicProvider;

  Future<CurrentPlayList> fetchCurrentPlayList() async {
    try {
      final response = await _myRoomMusicProvider.getCurrentPlayList();
      return response.map((item) => CurrentPlayList.fromJson(item)).first;
    } catch (e) {
      throw Exception('Failed to fetchCurrentPlayList: $e');
    }
  }

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
}

