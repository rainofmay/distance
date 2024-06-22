import 'package:flutter/material.dart';
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
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: 'Distance 탈퇴',
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 150,
            child: Column(
              children: [
                Text('탈퇴 시 유의사항', style: TextStyle(fontWeight: FontWeight.w500),),
                Text('내가 구매 및 설정한 배경, 프로필, 메이트 목록 및 메이트 간 대화 전체, 그리고 설정한 모든 정보는 사라지며 복구할 수 없습니다.'),
                Text('구독 해지에 관한 내용'),
              ],
            ),
          ),

          Column(
            children: [
              Row(
                children: [
                  CustomCheckBox(value: _isChecked, onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },),
                  Text('탈퇴 시 유의사항을 모두 확인하였습니다.')
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
                  style: TextStyle(fontSize: 16, color: WHITE),
                ),
                onPressed: () {
                  _customDialog(context);
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
            OkCancelButtons(okText: '확인', cancelText: '취소', onPressed: () {})
          ],
        );
      },
    );
  }
}
