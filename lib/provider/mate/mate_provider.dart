
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MateProvider {
  static final supabase = Supabase.instance.client;
  final userId = AuthHelper.getMyId();

  /* Get */
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
}


