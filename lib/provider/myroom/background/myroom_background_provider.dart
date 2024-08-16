import 'package:mobile/util/auth/auth_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyroomBackgroundProvider {
  static final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFirstPicture() async {
    final response;
    try {
      response = await supabase
          .from('background')
          .select("*")
          .eq('id', '505'); // 최초 배경 : Ocean 5번
    } catch (e) {
      throw Exception('Error fetching data: ${e}');
    }

    return response;
  }

  Future<List<Map<String, dynamic>>> getThemePictures(String category) async {
    final response;
    try {
      response = await supabase
          .from('background') // 테이블 이름
          .select("*")
          .eq('category', category) // 카테고리 필터링
          .eq('is_image', true); // isImage 값이 false인 것만 필터링
      print('[BackgroundProvider]: $response');
    } catch (e) {
      throw Exception('Error fetching data: ${e}');
    }

    return response;
  }

  Future<List<Map<String, dynamic>>> getThemeVideos(String category) async {
    final response;
    try {
      response = await supabase
          .from('background') // 테이블 이름
          .select()
          .eq('category', category) // 카테고리 필터링
          .eq('is_image', false); // isImage 값이 false인 것만 필터링
    } catch (e) {
      throw Exception('Error fetching data: ${e}');
    }

    return response;
  }

  Future<void> setBackgroundImage(String imageUrl) async {
    final currentUserId = await AuthHelper.getMyId();

    try {
      // user 테이블에서 현재 사용자의 background_url을 업데이트합니다.

      await supabase
          .from('user')
          .update({'background_url': imageUrl, 'is_image': true}).eq(
              'id', currentUserId as String);

      // 응답을 확인하여 업데이트가 성공적으로 이루어졌는지 확인합니다.
      print("image Upload Suceess");

      // 성공적으로 업데이트되면 아무것도 반환하지 않습니다.
    } catch (e) {
      // 오류가 발생하면 예외를 던집니다.
      throw Exception('Error setting background image: $e');
    }
  }

  Future<void> setBackgroundVideo(String videoUrl) async {
    final currentUserId = await AuthHelper.getMyId();

    try {
      // user 테이블에서 현재 사용자의 background_url을 업데이트합니다.
      await supabase
          .from('user')
          .update({'background_url': videoUrl, 'is_image': false}).eq(
              'id', currentUserId as String);
      // 성공적으로 업데이트되면 아무것도 반환하지 않습니다.
    } catch (e) {
      // 오류가 발생하면 예외를 던집니다.
      throw Exception('Error setting background image: $e');
    }
  }
}
