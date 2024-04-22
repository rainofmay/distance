import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/pop_up_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleCard extends StatelessWidget {
  final String id;
  final String scheduleName;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final bool isTimeSet;
  final String memo;
  final int sectionColor;

  ScheduleCard({
    required this.id,
    required this.scheduleName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isTimeSet,
    required this.memo,
    required this.sectionColor,
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0),
            child: Container(
              width: 5,
              height: 90,
              decoration: BoxDecoration(
                  color: sectionColors[sectionColor],
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 30, left: 5, bottom: 15),
              // height: 100,
              // decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.white.withOpacity(0.5),
              //     spreadRadius: 0,
              //     blurRadius: 2.0,
              //     offset: Offset(0, 1),
              //   ),
              // ],
              // ),
              child: Padding(
                padding: const EdgeInsets.only(
                    // 카드 안에서 텍스트의 패딩 간격
                    left: 12,
                    right: 12,
                    top: 12,
                    bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(scheduleName,
                            style: const TextStyle(fontSize: 15, color: BLACK)),
                        Text(
                          isTimeSet
                              ? startDate.day != endDate.day // 시간 설정 있고, 기간일 때
                                  ? startDate.year == endDate.year
                                      ? '${startDate.year}/${startDate.month}/${startDate.day} ~ ${endDate.month}/${endDate.day}'
                                      : '${startDate.year}/${startDate.month}/${startDate.day} ~ ${endDate.year}/${endDate.month}/${endDate.day}'
                                  : '$startTime~$endTime' // 하루일 때

                              : startDate.day != endDate.day // 시간 설정 없고 기간일 때,
                                  ? startDate.year == endDate.year
                                      ? '${startDate.year}/${startDate.month}/${startDate.day} ~ ${endDate.month}/${endDate.day}'
                                      : '${startDate.year}/${startDate.month}/${startDate.day} ~ ${endDate.year}/${endDate.month}/${endDate.day}'
                                  : '${startDate.year}/${startDate.month}/${startDate.day}',
                          style:
                              const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        alignment: Alignment.topLeft,
                        child: Text('# $memo',
                            style:
                                const TextStyle(fontSize: 12, color: BLACK))),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: PopUpMenu(
                        items: cardMoreOptions,
                        menuIcon: const Icon(Icons.more_horiz_rounded),
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
