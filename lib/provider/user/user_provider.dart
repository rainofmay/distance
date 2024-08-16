

import 'package:flutter/cupertino.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/util/user/uploadProfileImage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider {
  static final supabase = Supabase.instance.client;


  Future<Map<String, dynamic>?> getMyProfileJson() async {
    try {
      final sessionEmail = AuthHelper.getCurrentUserEmail();
      if (sessionEmail != null) {
        final response = await supabase
            .from('user') // 사용자 정보 테이블 이름
            .select()
            .eq('email', sessionEmail) // 사용자 이메일로 필터링
            .single();

        return response;
      }
      return null;
    }catch(err){
      print("[getMyProfileJson] Error : $err");
    }
    return null;
  }
  //
  // /* Get */
  // Future<Map<String, dynamic>?> getMyProfileJson() async {
  //   try {
  //     final myId = AuthHelper.getCurrentUserId();
  //     if (myId != null) {
  //       final response =
  //       await supabase.from('user').select().eq('id', myId).single();
  //       if (response != null) {
  //         return response;
  //       } else {
  //         // 데이터 조회 실패 시 에러 처리 (예: 빈 UserModel 객체 반환)
  //         return null;
  //       }
  //     } else {
  //       // 로그인되지 않은 경우 처리 (예: null 반환)
  //       return null;
  //     }
  //   } catch (error) {
  //     print('getMyProfileJson 에러 $error');
  //     // 에러 처리 (예: 에러 메시지 출력 또는 null 반환)
  //     return null;
  //   }
  // }

  /* UPDATE */
  Future<String?> editProfileImage(BuildContext context) async {
    try {
      final url = await uploadImage(context);
      final myId = await AuthHelper.getMyId();
      if (myId != null && url != null) {
        final response = await supabase
            .from('user')
            .update({'profile_url': url}).eq('id', myId);

        return url;

        if (response != null && response.error != null) {
          // null 확인 추가
          throw response.error!;
        } else {
          print("update ProfileImage to $url");
        }
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      print("[EditProfileImage Error] $e");
    }
    return null;
  }

  Future<void> editName(String newName) async {
    try {
      final myId = await AuthHelper.getMyId();
      if (myId != null) {
        final response = await supabase
            .from('user')
            .update({'nickname': newName}).eq('id', myId);

        if (response != null && response.error != null) {
          // null 확인 추가
          throw response.error!;
        } else {
          print("update UserName to $newName");
        }
      } else {
        throw Exception('User not logged in');
      }
    } catch (error) {
      print('에러 $error');
      throw error;
    }
  }

  Future<void> editIntroduction(String introduction) async {
    try {
      final myId = await AuthHelper.getMyId();
      if (myId != null) {
        await supabase
            .from('user') // 테이블 이름 확인 (user 모델에 맞게 수정)
            .update({'introduction': introduction}).eq(
            'id', myId); // uid를 기준으로 업데이트
        print("myId $myId");
        print("update Introduction to $introduction");
      } else {
        // 로그인되지 않은 경우 처리 (예: 에러 메시지 출력)
        throw Exception('User not logged in');
      }
    } catch (error) {
      print('에러 $error');
      // 에러 처리 (예: 에러 메시지 출력)
      throw error; // 상위 호출자에게 에러 전달
    }
  }

  Future<void> editStatusEmoji(String newStatusEmoji) async {
    try {
      final myId = await AuthHelper.getMyId();
      if (myId != null) {
        await supabase
            .from('user') // 테이블 이름 확인 (user 모델에 맞게 수정)
            .update({'status_emoji': newStatusEmoji}).eq(
            'id', myId); // uid를 기준으로 업데이트
        print("update status_emoji");
      } else {
        // 로그인되지 않은 경우 처리 (예: 에러 메시지 출력)
        throw Exception('User not logged in');
      }
    } catch (error) {
      print('에러 $error');
      // 에러 처리 (예: 에러 메시지 출력)
      throw error; // 상위 호출자에게 에러 전달
    }
  }

  Future<void> editStatusText(String newStatusText) async {
    try {
      final myId = await AuthHelper.getMyId();
      if (myId != null) {
        await supabase
            .from('user') // 테이블 이름 확인 (user 모델에 맞게 수정)
            .update({'status_text': newStatusText}).eq(
            'id', myId); // uid를 기준으로 업데이트
        print("update status_text");
      } else {
        // 로그인되지 않은 경우 처리 (예: 에러 메시지 출력)
        throw Exception('User not logged in');
      }
    } catch (error) {
      print('에러 $error');
      // 에러 처리 (예: 에러 메시지 출력)
      rethrow; // 상위 호출자에게 에러 전달
    }
  }

  Future<void> editStatusOnline(OnlineStatus status) async {
    final myId = await AuthHelper.getMyId();
    if (myId != null) {
      await supabase
          .from('user') // 테이블 이름 확인 (user 모델에 맞게 수정)
          .update({'online_status': status.stringValue}).eq(
          'id', myId); // uid를 기준으로 업데이트
    }
  }

  /* Delete */
  Future<void> updateUserSettings(bool isWordOpen, bool isScheduleOpen) async {
    final userId = await AuthHelper.getMyId();
    if (userId != null) {
      await supabase
        .from('user') // 테이블 이름 확인 (user 모델에 맞게 수정)
        .update({'is_word_open': isWordOpen}).eq(
        'id', userId); // uid를 기준으로 업데이트
      await supabase
          .from('user') // 테이블 이름 확인 (user 모델에 맞게 수정)
          .update({'is_schedule_open': isScheduleOpen}).eq(
          'id', userId); // uid를 기준으로 업데이트
  }
}
}
