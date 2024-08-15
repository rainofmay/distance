
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/widgets/custom_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MateProvider {
  static final supabase = Supabase.instance.client;
  final userId = AuthHelper.getMyId();

  /* Get */
  Future<List<Map<String, dynamic>>> getNotificationList() async {
    final userId = await AuthHelper.getMyId();

    try {
      final response = await supabase
          .from('notifications')
          .select('')
          .eq('receiver_id', '$userId')
          .order('created_at', ascending: false)
          .limit(10); // 최신 알림부터 최대 10개 정렬

      return response;

    } catch (error) {
      print('Error fetching notifications: $error');
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> getPendingRequests(String userEmail) async {
    final userId = await supabase
        .from('user')
        .select('id')
        .eq('email', userEmail)
        .single()
        .then((response) => response['id']);

    return await supabase
        .from('mate_relationships')
        .select()
        .eq('receiver_id', userId)
        .eq('is_friend', false)
        .order('created_at');
  }


  // 요청 받은 친구 리스트 띄우기
  Future<List<Map<String, dynamic>>> getFriendsList(String userId) async {
    return await supabase
        .from('mate_relationships')
        .select()
        .or('sender_id.eq.$userId, receiver_id.eq.$userId')
        .eq('is_friend', true)
        .order('created_at');
  }

  /* Post */
  Future<void> sendMateRequest(String senderId, String receiverId) async {
    await supabase
        .from('mate_relationships')
        .insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'body' : '$senderId님이 메이트를 요청했습니다.'
    });
  }

  /* Update */
  Future<void> acceptMateRequest(String requestId) async {
    final myId = await AuthHelper.getMyId(); // 현재 사용자 ID 가져오기
    final response = await supabase
        .from('mate_relationships')
        .select()
        .eq('sender_id', requestId)
        .eq('receiver_id', myId as Object); // receiver_id 확인 추가

    if (response.isNotEmpty) { // 요청이 존재하는 경우에만 승인 처리
      await supabase
          .from('mate_relationships')
          .update({'is_friend': true})
          .eq('sender_id', requestId)
          .eq('receiver_id', myId as Object); // receiver_id 조건 추가

      print("승인 완료!");
    } else {
      print("잘못된 요청입니다.");
      // 필요에 따라 에러 처리 추가 (예: 사용자에게 알림)
    }
  }
  /* Delete */
  Future<void> rejectMateRequest(String requestId) async {
    final myId = await AuthHelper.getMyId(); // 현재 사용자 ID 가져오기
    await supabase
        .from('mate_relationships')
        .delete()
        .eq('sender_id', requestId)
        .eq('receiver_id', myId as Object); // receiver_id 조건 추가

    print("거절 완료!");
  }

  Future searchUsersByEmail(String email) async {
    try {
      final response = await supabase
          .rpc('find_similar_emails', params: {'search_email': email});

      if (response.error != null) {
        print(response.error);
        throw response.error!;
      }
      print(response);
      return response;
    } catch (e) {
      print('Error searching users: $e');
      return [] ;
    }
  }
  Future<void> deleteMate(String deleteUid) async {
    final myId = await AuthHelper.getCurrentUserId();
    try {
      final response = await supabase
          .from('mate_relationships')
          .delete()
          .filter('is_friend', 'eq', true)
          .or('sender_id.eq.$myId,receiver_id.eq.$deleteUid,sender_id.eq.$deleteUid,receiver_id.eq.$myId');

      print("메이트 삭제 완료!");
      CustomSnackbar.show(title: '성공', message: '메이트가 삭제되었습니다.');
    } catch (e) {
      print('Error deleting mate: $e');
      CustomSnackbar.show(title: '오류', message: '메이트 삭제 중 오류가 발생했습니다.');
    }
  }

}


