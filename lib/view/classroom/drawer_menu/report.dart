import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class Report extends StatefulWidget {
  Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool _isChecked = false;
  final List<String> _reportList = [
    '스팸, 유해, 음란물, 악성 링크 등의 유포 행위',
    '아동 및 성적 학대, 언행 또는 그에 관한 정보 노출',
    '자해, 물리적,사이버공격 등 위험 노출',
    '도용 계정, 계좌, 카드 등의 유포',
    '마약 및 기타 불법 상품 등에 관한 거래, 정보',
  ];

  Future<void> _customDialog(BuildContext context) {
    // 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          backgroundColor: WHITE,
          title: const Text('신고하시겠습니까?',
              style: TextStyle(color: Colors.black, fontSize: 17)),
          content: const Text(
            '허위 신고는 제재를 받을 수 있습니다.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          actions: [
            OkCancelButtons(okText: '제출', cancelText: '취소', onPressed: () {})
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '신고하기',
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _reportList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: ListTile(
                  leading: Checkbox(
                    value: _isChecked,
                    onChanged: (value) => {
                      setState(() {
                        _isChecked = value!;
                      })
                    },
                    activeColor: Colors.red[800],
                    checkColor: WHITE,
                    splashRadius: 0,
                    hoverColor: TRANSPARENT,

                  ),
                  title: Text(_reportList[index]),
                ),
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              minimumSize: Size(screenWidth, 50),
              backgroundColor: Colors.red[800],
            ),
            child: Text(
              '신고 제출하기',
              style: TextStyle(fontSize: 16, color: WHITE),
            ),
            onPressed: () {
              _customDialog(context);
            },
          )
        ],
      ),
    );
  }
}
