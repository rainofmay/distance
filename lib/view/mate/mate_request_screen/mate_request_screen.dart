import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';

class MateRequestsScreen extends StatefulWidget {
  final MateViewModel viewModel = Get.find<MateViewModel>();
  final TextEditingController _emailController = TextEditingController();

  MateRequestsScreen({super.key});

  @override
  State<MateRequestsScreen> createState() => _MateRequestsScreenState();
}

class _MateRequestsScreenState extends State<MateRequestsScreen> {
  final int _maxLength = 20;

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    widget._emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
          appbarTitle: '메이트 추가',
          isLeading: true,
          isCenterTitle: true,
          backgroundColor: WHITE,
          contentColor: BLACK),
      body: Column(
        children: [
          Padding(
            // 이메일 입력 필드 추가
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: widget._emailController,
                    fieldWidth: MediaQuery.of(context).size.width * 0.9,
                    isPasswordField: false,
                    isReadOnly: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: _validator,
                    maxLines: 1,
                    hintText: "메이트 ID를 입력해 주세요",
                    suffixWidget: GestureDetector(
                      onTap: () {
                        widget._emailController.text = "";
                      },
                      child: Icon(Icons.cancel_rounded, size: 15, color: GREY),
                    ),
                  ),
                  // suffixIcon: Icon(Icons.cancel_rounded, size: 15, color: GREY),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final email = widget._emailController.text.trim();
                    if (email.isNotEmpty) {
                      await widget.viewModel
                          .sendMateRequestByEmail(email); // 이메일로 친구 요청
                      widget._emailController.clear();
                    } else {
                      // TODO: 이메일 입력 필드가 비어있을 때 처리
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                    child: const Icon(Icons.search),
                  ),
                )
              ],
            ),
          ),
          // TextFormField(
          //   cursorColor: SECONDARY,
          //   controller: _emailController,
          //   decoration: InputDecoration(
          //     hintText: '친구 ID 입력',
          //     hoverColor: SECONDARY,
          //     focusedBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(color: SECONDARY),
          //     ),
          //     enabledBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(color: GREY),
          //     ),
          //
          //   ),
          // ),
          Expanded(
            child: Obx(() {
              // Obx 위젯으로 pendingMateProfiles 변경 감지
              final requests = widget.viewModel.pendingMateProfiles;
              return RefreshIndicator(
                onRefresh: () async {
                  await widget.viewModel.getPendingMates();
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
                            onPressed: () =>
                                widget.viewModel.acceptMate(request.id!),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: PRIMARY_COLOR), // ID 전달
                            child: Text('승인'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                widget.viewModel.rejectMate(request.id!),
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

  String? _validator(value) {}
}
