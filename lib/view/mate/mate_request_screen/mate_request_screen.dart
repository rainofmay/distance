import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';

class MateRequestsScreen extends StatelessWidget {
  final MateViewModel viewModel = Get.find<MateViewModel>();
  final TextEditingController _emailController = TextEditingController();
  MateRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mate 요청'),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: Column(
        children: [
          Padding(
            // 이메일 입력 필드 추가
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: '친구 이메일 입력',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text.trim();
              if (email.isNotEmpty) {
                await viewModel.sendMateRequestByEmail(email); // 이메일로 친구 요청
                _emailController.clear();
              } else {
                // TODO: 이메일 입력 필드가 비어있을 때 처리
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
            child: Text('검색하기'),
          ),
          Expanded(
            child: Obx(() {
              // Obx 위젯으로 pendingMateProfiles 변경 감지
              final requests = viewModel.pendingMateProfiles;
              return RefreshIndicator(
                onRefresh: () async {
                  await viewModel.getPendingMates();
                },
                child: ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index].value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: GREY.withOpacity(0.5),
                                  backgroundImage: NetworkImage(
                                      request.profileUrl ?? ''), // null 처리
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(request.name ?? '',
                                        style: TextStyle(
                                            fontSize: 13, color: BLACK)),
                                    // null 처리
                                    SizedBox(height: 5),
                                    Text(request.introduction ?? '',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: DARK_UNSELECTED)),
                                    // null 처리
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => viewModel.acceptMate(request.id!),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: PRIMARY_COLOR), // ID 전달
                            child: Text('승인'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => viewModel.rejectMate(request.id!),
                            style:
                                ElevatedButton.styleFrom(backgroundColor: GREY),
                            // ID 전달
                            child: Text('거절'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
