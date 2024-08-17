import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';

class MateRequestsScreen extends StatelessWidget {
  MateRequestsScreen({super.key});

  final MateViewModel viewModel = Get.find<MateViewModel>();

  String? _validator(value) {}
  final userEmail = AuthHelper.getCurrentUserEmail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        appbarTitle: '메이트 찾기',
        isLeading: true,
        isCenterTitle: true,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddMateSection(context),
          _buildDivider(),
          _buildMateRequestListSection(),
        ],
      ),
    );
  }

  Widget _buildAddMateSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '메이트 추가',
            style: TextStyle(fontSize: 16, color: BLACK),
          ),
          const SizedBox(height: 8),
          Text(
            userEmail != null ? "내 E-mail: $userEmail" : "로그인 후 이용해주세요!",
            style: const TextStyle(fontSize: 11, color: GREY),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: viewModel.emailController,
                  fieldWidth: MediaQuery.of(context).size.width * 0.7,
                  isPasswordField: false,
                  isReadOnly: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: _validator,
                  maxLines: 1,
                  hintText: "메이트 E-mail을 입력해 주세요",
                  suffixWidget: GestureDetector(
                    onTap: () {
                      viewModel.emailController.text = "";
                    },
                    child: const Icon(Icons.cancel_rounded, size: 15, color: GREY),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  // email : 상대방 이메일
                  final email = viewModel.emailController.text.trim();
                  if (email.isNotEmpty) {
                    await viewModel.sendMateRequestByEmail(email);
                    viewModel.emailController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DARK_BACKGROUND,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('추가', style: TextStyle(color: PRIMARY_LIGHT)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 3,
      color: Colors.grey[200],
    );
  }

  Widget _buildMateRequestListSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              '메이트 요청 목록',
              style: TextStyle(fontSize: 16, color: BLACK),
            ),
          ),
          Expanded(
            child: Obx(() {
              final requests = viewModel.pendingMateProfiles;
              return RefreshIndicator(
                backgroundColor: WHITE,
                color: PRIMARY_COLOR,
                onRefresh: () async {
                  await viewModel.getPendingMates();
                },
                child: requests.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                  itemCount: requests.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final request = requests[index].value;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: GREY.withOpacity(0.5),
                        backgroundImage: NetworkImage(request.profileUrl ?? ''),
                      ),
                      title: Text(request.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(request.introduction ?? '', style: const TextStyle(color: DARK_UNSELECTED, fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => viewModel.acceptMate(request.id!),
                            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                            child: const Text('승인', style: TextStyle(color: BLACK)),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => viewModel.rejectMate(request.id!),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: GREY)),
                            child: const Text('거절', style: TextStyle(color: BLACK)),
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

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Center(
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.person_2_fill, size: 52, color: DARK_UNSELECTED),
              SizedBox(height: 16),
              Text(
                '메이트 요청이 없습니다.',
                style: TextStyle(fontSize: 14, color: DARK_UNSELECTED),
              ),
              SizedBox(height: 16),
              // Text(
              //   '아래로 당겨서 새로고침',
              //   style: TextStyle(fontSize: 14, color: GREY),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

