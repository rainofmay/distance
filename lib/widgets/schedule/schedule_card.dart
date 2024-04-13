import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/pop_up_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleCard extends StatelessWidget {
  final String id;
  final String scheduleName;
  final DateTime selectedDate;
  final String startTime;
  final String endTime;
  final String memo;
  final int selectedColor;
  final bool isDone;

  ScheduleCard({
    required this.id,
    required this.scheduleName,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.memo,
    required this.selectedColor,
    required this.isDone,
    super.key,
  });

  final List<String> cardMoreOptions = ["날짜 이동", "복사", "수정", "삭제"];

  void _handleMenuOptions(String item) async {
    if (item == '날짜 이동') {
      // 추가 동작 수행
    } else if (item == '복사') {
      // 수정 동작 수행
    } else if (item == '수정') {
      // 삭제 동작 수행
    } else if (item == '삭제') {
      await Supabase.instance.client.from('schedule').delete().match({
        'id': id,
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 30, left: 20, bottom: 15),
              // height: 100,
              decoration: BoxDecoration(
                  color: cardColor[selectedColor][0],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 2.0,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  // border: Border(
                  //   left: BorderSide(color: Colors.indigo, width: 1.5),
                  // ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  // 카드 안에서 텍스트의 패딩 간격
                    left: 12, right: 12, top : 12, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          scheduleName,
                          style: TextStyle(
                              fontSize: 15,
                              color: cardColor[selectedColor][1]),
                        ),
                        Text(
                          '$startTime~$endTime',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(top:10, left: 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          '# $memo',
                          style: TextStyle(
                              fontSize: 12,
                              color: cardColor[selectedColor][1]),
                        )),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: PopUpMenu(
                        items: cardMoreOptions,
                        menuIcon: Icon(Icons.more_horiz_rounded),
                        onItemSelected: _handleMenuOptions,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
