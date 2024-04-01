import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class Report extends StatefulWidget {
  Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final List<String> _reportList = [
    '스팸, 유해, 음란물, 악성 링크 등의 유포 행위',
    '아동 및 성적 학대, 언행 또는 그에 관한 정보 노출',
    '자해, 물리적,사이버공격 등 위험 노출',
    '도용 계정, 계좌, 카드 등의 유포',
    '마약 및 기타 불법 상품 등에 관한 거래, 정보',
    '기타 내용 신고하기'
  ];

  Future<void> _customDialog(BuildContext context) {
    // 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          backgroundColor: WHITE,
          title: const Text('신고하시겠습니까?', style: TextStyle(color: Colors.black, fontSize: 17)),
          content: const Text('허위 신고는 제재를 받을 수 있습니다.', style: TextStyle(color: Colors.grey, fontSize: 11),),
          actions: [
            OkCancelButtons(okText: '제출', cancelText: '취소', onPressed: () {})
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: '신고하기',
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
        isEndDrawer: false,
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _reportList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Checkbox(
                  value: false,
                  onChanged: (value) {
                    setState() {}
                  },
                ),
                title: Text(_reportList[index]),
              );
            },
          ),
          TextButton(
            child: Text('신고 제출'),
            onPressed: () {_customDialog(context);},
          )
        ],
      ),
    );
  }
}
