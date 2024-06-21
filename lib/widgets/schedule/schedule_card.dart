import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/util/modifying_schedule_provider.dart';
import 'package:provider/provider.dart';
import '../../view/schedule/schedule/modify_schedule.dart';
import '../../util/schedule_color_provider.dart';

class ScheduleCard extends StatefulWidget {
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

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 빈 영역도 터치되도록

      // 수정 모드 들어갈 때,
      onTap: () async {
        // 고유 schedule 값 인식시키기
        await context.read<ModifyingScheduleProvider>().setModyfing(widget.id);

        if (!context.mounted) return;
        context.read<ScheduleColorProvider>().setColorIndex(widget.sectionColor);

        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ModifySchedule(),
                ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0),
            child: Container(
              width: 5,
              height: 90,
              decoration: BoxDecoration(
                  color: sectionColors[widget.sectionColor],
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
                        Text(widget.scheduleName,
                            style: const TextStyle(fontSize: 15, color: BLACK)),
                        Text(
                          widget.isTimeSet
                              ? widget.startDate.day !=
                                      widget.endDate.day // 시간 설정 있고, 기간일 때
                                  ? widget.startDate.year == widget.endDate.year
                                      ? '${widget.startDate.year}/${widget.startDate.month}/${widget.startDate.day} ~ ${widget.endDate.month}/${widget.endDate.day}'
                                      : '${widget.startDate.year}/${widget.startDate.month}/${widget.startDate.day} ~ ${widget.endDate.year}/${widget.endDate.month}/${widget.endDate.day}'
                                  : '${widget.startTime}~${widget.endTime}' // 하루일 때

                              : widget.startDate.day !=
                                      widget.endDate.day // 시간 설정 없고 기간일 때,
                                  ? widget.startDate.year == widget.endDate.year
                                      ? '${widget.startDate.year}/${widget.startDate.month}/${widget.startDate.day} ~ ${widget.endDate.month}/${widget.endDate.day}'
                                      : '${widget.startDate.year}/${widget.startDate.month}/${widget.startDate.day} ~ ${widget.endDate.year}/${widget.endDate.month}/${widget.endDate.day}'
                                  : '${widget.startDate.year}/${widget.startDate.month}/${widget.startDate.day}',
                          style:
                              const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        alignment: Alignment.topLeft,
                        child: Text('# ${widget.memo}',
                            style:
                                const TextStyle(fontSize: 12, color: BLACK))),
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
