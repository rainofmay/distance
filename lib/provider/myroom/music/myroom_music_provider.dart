import 'package:supabase_flutter/supabase_flutter.dart';

class MyRoomMusicProvider {
  static final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getThemeMusic(String theme) async {
    final response;
    try {
      response = await supabase
          .from('music') // 테이블 이름
          .select('*')
          .eq('theme', theme); // 카테고리 필터링
      print('[MusicProvider]: $response');
      return List<Map<String, dynamic>>.from(response);
    }
    catch (e) {
      throw Exception('Error fetching getThemeMusic: ${e}');
    }
  }
}