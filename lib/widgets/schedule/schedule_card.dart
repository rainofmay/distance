import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/pop_up_menu.dart';

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
  final List<String> cardItems = ["다른 날짜 이동/복사", "수정", "삭제"];
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
              margin: EdgeInsets.only(right: 30, left: 20, bottom: 20),
              height: 100,
              decoration: BoxDecoration(
                  color: cardColor[selectedColor][0],
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(color: Colors.indigo, width: 1.5),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 10, bottom: 0),
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
                        padding: EdgeInsets.only(left: 10),
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
                        items: cardItems,
                        menuIcon: Icon(Icons.more_horiz_rounded),
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
