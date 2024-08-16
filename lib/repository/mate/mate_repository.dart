import 'dart:async';
import 'package:intl/intl.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/provider/mate/mate_provider.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/widgets/custom_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MateRepository {
  late final MateProvider _mateProvider;
  static final supabase = Supabase.instance.client;

  MateRepository({
    required MateProvider mateProvider,
  }) : _mateProvider = mateProvider;


  Future<List<Map<String, String>>> fetchNotificationList() async {
    try {
      final rawNotifications = await _mateProvider.getNotificationList();

      return rawNotifications.map((n) {
        final DateTime date = DateTime.parse(n['created_at']);
        return {
          'body': n['body'] as String,
          'date': DateFormat('yyyy. MM. dd.').format(date),
        };
      }).toList();
    } catch (error) {
      print('Repository error fetching notifications: $error');
      rethrow;
    }
  }

  //친구 요청을 받지 않은 친구들
  Future<List<UserModel>> fetchPendingRequests() async {
    late final List<UserModel> data;
    final userEmail = await AuthHelper.getCurrentUserEmail();
    final response = await _mateProvider.getPendingRequests(userEmail!);

    // 친구 ID 목록 생성
    final friendIds = response.map((mate) {
      return mate['sender_id'];
    }).toList();

    // 친구 ID 목록을 사용하여 사용자 정보 가져오기
    List<Map<String, dynamic>> userResponse = [];
    for (var friendId in friendIds) {
      final userData = await supabase
          .from('user')
          .select()
          .eq('id', friendId)
          .single();
      userResponse.add(userData);
    }

    // 사용자 정보를 UserModel 객체로 변환
    final userModels = UserModel.fromJsonList(userResponse);

    return userModels;
  }

  //이미 친구인 친구들
  Future<List<UserModel>> fetchMyMates() async {
    // 현재 사용자의 ID 가져오기
    final userId = await AuthHelper.getMyId();

    // 친구 관계 데이터 가져오기
    final response = await _mateProvider.getFriendsList(userId!);

    // 친구 ID 목록 생성
    final friendIds = response.map((mate) {
      return mate['sender_id'] == userId
          ? mate['receiver_id']
          : mate['sender_id'];
    }).toList();

    // 친구 ID 목록을 사용하여 사용자 정보 가져오기
    List<Map<String, dynamic>> userResponse = [];
    for (var friendId in friendIds) {
      final userData = await supabase
          .from('user')
          .select()
          .eq('id', friendId)
          .single();
      userResponse.add(userData);
    }

    // 사용자 정보를 UserModel 객체로 변환
    final userModels = UserModel.fromJsonList(userResponse);

    return userModels;
  }


  //친구 요청 보내기
  Future<void> sendMateRequestByEmail(String email) async {
    try {
      final userEmail = await AuthHelper.getCurrentUserEmail();
      final receiverUserId = await getUserIdByEmail(email);
      final senderUserId = await getUserIdByEmail(userEmail!);
      if (receiverUserId != null &&
          email != userEmail) { // 사용자가 존재하고, 자신에게 요청을 보내는 것이 아닌 경우
        // 이미 친구 요청을 보냈는지 확인
        final existingRequest = await supabase
            .from('mate_relationships')
            .select()
            .eq('sender_id', senderUserId as String)
            .eq('receiver_id', receiverUserId);

        if (existingRequest?.isNotEmpty ?? false) { // 이미 요청을 보낸 경우
          CustomSnackbar.show(
              title: '알림', message: '이미 해당 사용자에게 메이트 요청을 보냈습니다.');
        } else { // 새로운 요청을 보내는 경우
          await _mateProvider.sendMateRequest(senderUserId, receiverUserId);
          await mateRequestNotification(
              senderUserId, receiverUserId); // Notification
          CustomSnackbar.show(title: '완료', message: '메이트 요청을 보냈습니다.');
        }
      } else if (email == userEmail) { // 자신에게 요청을 보내는 경우
        CustomSnackbar.show(title: '오류', message: '자신에게 메이트 요청을 보낼 수 없습니다.');
      } else { // 사용자를 찾을 수 없는 경우
        CustomSnackbar.show(title: '오류', message: '해당 이메일의 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      // 에러 처리
      print('Error sending mate request: $e');
      CustomSnackbar.show(title: '오류', message: '메이트 요청 중 오류가 발생했습니다.');
    }
  }

  Future<String?> getUserIdByEmail(String email) async {
    final response = await MateProvider.supabase
        .from('user')
        .select('id')
        .eq('email', email)
        .single(); // 단일 결과 반환
    return response['id'];
  }

  //친구 찾기
  Future<List<UserModel>> searchMatesByEmail(String email) async {
    try {
      final response = await _mateProvider.searchUsersByEmail(email);
      if (response.error != null) {
        throw response.error!;
      }
      // 검색 결과를 UserModel 객체 리스트로 변환
      List<UserModel> users = (response.data as List<dynamic>).map((userData) {
        // similarity 필드를 제거하고 나머지 데이터로 UserModel 생성
        Map<String, dynamic> userMap = Map<String, dynamic>.from(userData);
        userMap.remove('similarity');
        return UserModel.fromJson(userMap);
      }).toList();

      return users;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }


  //친구 승인
  Future<void> handleAccept(String requestId) async {
    try {
      await _mateProvider.acceptMateRequest(requestId);
      await mateAcceptNotification(requestId); // 승인 Notification
      CustomSnackbar.show(title: '완료', message: '메이트 요청이 승인되었습니다.');
      fetchMyMates();
    }
    catch (e) {
      print('$e');
    }
  }

  //친구 거절
  Future<void> handleReject(String requestId) async {
    await _mateProvider.rejectMateRequest(requestId);
    fetchMyMates();
  }

  /* 친구 요청 시 Notification - 수정된 버전 */
  Future<void> mateRequestNotification(String senderId,
      String receiverId) async {
    try {
      String senderNickname = await AuthHelper.getNicknameById(senderId);
      await supabase.from('notifications').insert({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'body': '$senderNickname님이 메이트 요청을 보냈습니다.'
      });

      print('Mate request notification sent successfully');
    } catch (error) {
      print('Error sending mate request notification: $error');
    }
  }

  /* 친구 승인 시 Notification */
  Future<void> mateAcceptNotification(String requestId) async {
    final accepterEmail = await AuthHelper.getCurrentUserEmail();
    final acceptId = await getUserIdByEmail(accepterEmail!);
    final acceptName = await AuthHelper.getNicknameById(acceptId!);

    try {
      // final requestData = await supabase
      //     .from('users')
      //     .select('nickname')
      //     .eq('id', requestId)
      //     .single();
      //
      // if (requestData == null) {
      //   throw Exception('Requester not found');
      // }
      //
      // final requesterName = requestData['nickname'] as String;

      await supabase.from('notifications').insert({
        'sender_id': acceptId, // 승인하는 사용자
        'receiver_id': requestId, // 요청했던 사용자(에게 알림이 가야함)
        'body': '$acceptName님이 메이트 요청을 승인했습니다.'
      });
    } catch (error) {
      print('Error requesting mate request notification: $error');
    }
  }

  Future<void> deleteMate(String deleteUid) async {
    await _mateProvider.deleteMate(deleteUid);
    await fetchMyMates();
  }
}


