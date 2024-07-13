import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthHelper {
  // 클래스로 만들어 재사용성 높이기
  static final _supabase = Supabase.instance.client;

  static User? getCurrentUser() {
    final session = _supabase.auth.currentSession;
    return session?.user; // 세션이 있으면 user 반환, 없으면 null 반환
  }

  static String? getCurrentUserId() {
    final user = getCurrentUser();
    return user?.id; // user가 있으면 id 반환, 없으면 null 반환
  }

  static bool isLoggedIn() {
    return getCurrentUser() != null;
  }


  //토큰이 있으면 그걸로 식별을 하고, 그게 아니면 로그인 창으로 내보낸다.
  static Future<String?> getMyId() async {
    if (!isLoggedIn()) {
      Get.offAllNamed('/login');
      return null;
    }
    final userId = getCurrentUserId();
    if (userId != null) {
      final response = await _supabase
          .from('user')
          .select('id')
          .eq('uid', userId)
          .single();
      return response['id']; // 문자열 형태로 반환
    } else {
      return null;
    }
  }
  static Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    final response = await _supabase
        .from('user') // 사용자 정보 테이블 이름
        .select()
        .eq('id', userId) // 사용자 ID로 필터링
        .single();

    return response;
  }

}
