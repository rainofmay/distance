import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class ScheduleCard extends StatefulWidget {
  final String scheduleName;
  final DateTime selectedDate;
  final String startTime;
  final String endTime;
  final String memo;
  final int selectedColor;

  const ScheduleCard({
    required this.scheduleName,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.memo,
    required this.selectedColor,
    super.key,
  });

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  // fillColor: const MaterialStatePropertyAll(Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  value: isDone,
                  onChanged: (newValue) {
                    // 여기에 파이어베이스 UPDATE 코드 필요.
                    setState(() {
                      isDone = newValue!;
                    },
                    );
                  },
                activeColor: cardColor[widget.selectedColor][0],
                checkColor: cardColor[widget.selectedColor][1]),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 16, left: 16, bottom: 20),
              height: 120,
              decoration: BoxDecoration(
                color: cardColor[widget.selectedColor][0],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_horiz_rounded),
                          color: cardColor[widget.selectedColor][1]),
                    ),
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