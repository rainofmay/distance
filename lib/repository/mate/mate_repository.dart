
import 'package:get/get.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/provider/mate/mate_provider.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MateRepository {
  late final MateProvider _mateProvider;
  static final supabase = Supabase.instance.client;

  MateRepository({
    required MateProvider mateProvider,
  }) : _mateProvider = mateProvider;

  onInit() {

  }

  //친구 요청을 받지 않은 친구들
  Future<List<UserModel>> fetchPendingRequests() async {
    late final List<UserModel> data;
    final userId = await AuthHelper.getMyId();
    final response = await _mateProvider.getPendingRequests(userId!);

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
      return mate['sender_id'] == userId ? mate['receiver_id'] : mate['sender_id'];
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


  //친구요청 보내기
  Future<void> sendMateRequestByEmail(String email) async {
    try {
      final myId = await AuthHelper.getMyId(); // 현재 사용자 ID 가져오기
      final requestUserId = await getUserIdByEmail(email);

      if (requestUserId != null && requestUserId != myId) { // 사용자가 존재하고, 자신에게 요청을 보내는 것이 아닌 경우
        // 이미 친구 요청을 보냈는지 확인
        final existingRequest = await supabase
            .from('mate_relationships')
            .select()
            .eq('sender_id', myId as String)
            .eq('receiver_id', requestUserId);

        if (existingRequest?.isNotEmpty ?? false) { // 이미 요청을 보낸 경우
          Get.snackbar('이미 요청됨', '이미 해당 사용자에게 메이트 요청을 보냈습니다.');
        } else { // 새로운 요청을 보내는 경우
          await _mateProvider.sendMateRequest(myId!, requestUserId);
          Get.snackbar('요청 완료', '메이트 요청을 보냈습니다.');
        }
      } else if (requestUserId == myId) { // 자신에게 요청을 보내는 경우
        Get.snackbar('오류', '자신에게 메이트 요청을 보낼 수 없습니다.');
      } else { // 사용자를 찾을 수 없는 경우
        Get.snackbar('오류', '해당 이메일의 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      // 에러 처리
      print('Error sending mate request: $e');
      Get.snackbar('오류', '메이트 요청 중 오류가 발생했습니다.');
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
    await _mateProvider.acceptMateRequest(requestId);
    fetchMyMates();
  }
  //친구 거절
  Future<void> handleReject(String requestId) async {
    await _mateProvider.rejectMateRequest(requestId);
    fetchMyMates();
  }

}
