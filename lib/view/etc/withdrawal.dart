import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view/mate/widget/custom_dialog.dart';
import 'package:mobile/view_model/user/login_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';

import '../../common/const/colors.dart';
import '../../widgets/custom_check_box.dart';
import '../../widgets/ok_cancel._buttons.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({super.key});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {

  final LoginViewModel loginViewModel = Get.find<LoginViewModel>();
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: 'Distance 탈퇴',
        isCenterTitle: true,
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: DefaultTextStyle(
              style: TextStyle(
                height: 2.7,
                color: BLACK,
                fontFamily: 'GmarketSansTTFMedium',
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text('탈퇴 시 유의사항',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 32),
                  Text(
                      '1. 사용자가 설정한 배경, 음악, 프로필, 메이트 등에 관한 모든 정보는 사라지며 복구할 수 없습니다.',
                      style: TextStyle(fontSize: 16),
                      softWrap: true),

                  SizedBox(height: 32),
                  Text('2. 본 애플리케이션 서비스는 귀하의 개인정보 저장, 활용 등의 행위를 일체 하지 않습니다.',
                      style: TextStyle(fontSize: 16), softWrap: true),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  CustomCheckBox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                    radius: 50,
                  ),
                  Text('탈퇴 시 유의사항을 모두 확인하였습니다.',
                      style: TextStyle(color: _isChecked ? BLACK : GREY))
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  minimumSize: Size(screenWidth, 50),
                  backgroundColor: BLACK,
                ),
                child: Text(
                  '탈퇴하기',
                  style:
                      TextStyle(fontSize: 16, color: _isChecked ? WHITE : GREY),
                ),
                onPressed: () {
                  _isChecked
                      ? customDialog(
                          context,
                          40,
                          '정말 탈퇴하시겠습니까?',
                          Text('탈퇴하면 모든 정보가 삭제됩니다.', style: TextStyle(color: TRANSPARENT_WHITE)),
                          OkCancelButtons(okText: '확인', onPressed: () {
                            loginViewModel.deleteAccount(context);
                          }, cancelText: '취소',))
                      : null;
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _customDialog(BuildContext context) {
    // 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          backgroundColor: WHITE,
          title: const Text('탈퇴하시겠습니까?',
              style: TextStyle(color: Colors.black, fontSize: 17)),
          content: const Text(
            '탈퇴하면 모든 정보가 사라집니다.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          actions: [
            OkCancelButtons(
                okText: '확인',
                cancelText: '취소',
                okTextColor: BLACK,
                cancelTextColor: BLACK,
                onPressed: () {})
          ],
        );
      },
    );
  }
}
