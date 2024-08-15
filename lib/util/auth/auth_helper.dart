import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/login/login_screen.dart';
import 'package:mobile/view/mate/widget/custom_dialog.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthHelper {
  // 클래스로 만들어 재사용성 높이기
  static final _supabase = Supabase.instance.client;

  static User? getCurrentSessionUser() {
    final session = _supabase.auth.currentSession;
    return session?.user; // 세션이 있으면 user 반환, 없으면 null 반환
  }

  static String? getCurrentUserId() {
    final user = getCurrentSessionUser();
    print("getCurrentUserId : ${user?.id}");
    return user?.id; // user가 있으면 id 반환, 없으면 null 반환
  }

  static bool isLoggedIn() {
    return getCurrentSessionUser() != null;
  }

  static Future<String?> getOtherUserNickname(String id) async {
    try {
      final response = await _supabase.from('user')
          .select('nickname')
          .eq('id', id)
          .single();

      return response['nickname'] as String;
    } catch (error) {
      print('Error fetching nickname: $error');
      rethrow;
    }
  }
  //토큰이 있으면 그걸로 식별을 하고, 그게 아니면 로그인 창으로 내보낸다.
  static Future<String?> getMyId() async {
    if (!isLoggedIn()) {
      print("로그인이 안 되어있습니다.");
      return null;
    }
    final userEmail = getCurrentUserEmail();
    if (userEmail != null) {
      final response = await _supabase
          .from('user')
          .select('id')
          .eq('email', userEmail)
          .single();
      return response['id']; // 문자열 형태로 반환
    } else {
      print("getCurrentUserId: error");
      return null;
    }
  }

  static String? getCurrentUserEmail() {
    final user = getCurrentSessionUser();
    return user?.email; // user가 있으면 email 반환, 없으면 null 반환
  }

  static Future<void> navigateToLoginScreen(BuildContext context, void Function() navigate) async {
    String? userEmail = await getCurrentUserEmail();
    if (userEmail == null) {
      if (!context.mounted) return;
      return customDialog(context, 40, '로그인', const Text('로그인이 필요합니다. 하시겠습니까?', style: TextStyle(color: WHITE)),
          OkCancelButtons(okText: '확인', okTextColor: PRIMARY_COLOR, onPressed: () {
            Navigator.of(context).pop();
            Get.to(() => LoginScreen(), preventDuplicates: true);
          }, cancelText: '취소', onCancelPressed: () {
            Navigator.of(context).pop();
          }));
    } else {
      navigate();
      print("로그인 된 사용자 Email: $userEmail");
    }
  }
}
