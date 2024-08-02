
import 'package:supabase_flutter/supabase_flutter.dart';

class MyroomBackgroundProvider {
  static final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFirstPicture() async {
    final response;
    try{
      response = await supabase
          .from('background') // 테이블 이름
          .select("*")
          .eq('id', '40'); // 카테고리 필터링
    }
    catch(e){
      throw Exception('Error fetching data: ${e}');
    }

    return response;
  }

  Future<List<Map<String, dynamic>>> getThemePictures(String category) async {
    final response;
    try{
       response = await supabase
          .from('background') // 테이블 이름
          .select("*")
          .eq('category', category) // 카테고리 필터링
          .eq('is_image', true); // isImage 값이 false인 것만 필터링
      print('[BackgroundProvider]: $response');
    }
    catch(e){
      throw Exception('Error fetching data: ${e}');
    }

    return response;
  }

  Future<List<Map<String, dynamic>>> getThemeVideos(String category) async {
    final response;
    try{
      response = await supabase
          .from('background') // 테이블 이름
          .select()
          .eq('category', category) // 카테고리 필터링
          .eq('is_image', false); // isImage 값이 false인 것만 필터링
    }
    catch(e){
      throw Exception('Error fetching data: ${e}');
    }

    return response;
  }
}
