
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/schedule/schedule_bottom_sheet.dart';
import 'package:mobile/model/schedule_model.dart';

class ScheduleCard extends StatefulWidget {
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

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  // late bool isDone ;

  @override
  // void initState() {
  //   super.initState();
  //   isDone = widget.isDone;
  // }
  //
  // updateToggle(newValue) async{
  //   print('updateToggle: ${newValue}');
  //   setState(() {
  //     isDone = newValue;
  //     print(widget.isDone);
  //   });
  //   await FirebaseFirestore.instance.collection('schedule').doc(widget.id).update({'isDone': isDone});
  // }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              height: 100,
              decoration: BoxDecoration(
                color: cardColor[widget.selectedColor][0],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:12, right: 12, top:10, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.scheduleName,
                          style: TextStyle(fontSize: 15, color: cardColor[widget.selectedColor][1]),
                        ),
                        Text(
                          '${widget.startTime}~${widget.endTime}',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          '# ${widget.memo}',
                          style: TextStyle(fontSize: 12, color: cardColor[widget.selectedColor][1]),
                        )),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          color: BLACK,
                          elevation: 10,
                          tooltip: "",
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return [
                              _menuItem("다른 날짜 이동/복사"),
                              _menuItem("수정"),
                              _menuItem("삭제"),
                            ];
                          },
                          constraints: const BoxConstraints(minWidth: 50, maxWidth: 120),
                          splashRadius: null,
                          enabled: true,
                          icon: Icon(Icons.more_horiz_rounded),
                    ),)
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

PopupMenuItem<String> _menuItem(String text) {
  return PopupMenuItem<String>(
    enabled: true,

    /// 해당 항목 선택 시 호출
    onTap: () {},

    /// value = value에 입력한 값이 PopupMenuButton의 initialValue와 같다면
    /// 해당 아이템 선택된 UI 효과 나타남
    /// 만약 원하지 않는다면 Theme 에서 highlightColor: Colors.transparent 설정
    value: text,
    height: 40,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
