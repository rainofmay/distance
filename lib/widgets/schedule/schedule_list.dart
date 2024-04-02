import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/widgets/schedule/schedule_card.dart';

class ScheduleList extends StatefulWidget {
  final selectedDate;

  const ScheduleList({super.key, required this.selectedDate});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  TextEditingController introduceController = TextEditingController();
  List<Map<String, dynamic>> scheduleList = [];
  String? _error; //_err

  void _deleteTodo(int index) {}

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('schedule')
          .where(
            'selectedDate',
            isEqualTo:
                '${widget.selectedDate.year}${widget.selectedDate.month.toString().padLeft(2, '0')}${widget.selectedDate.day.toString().padLeft(2, '0')}',
          )
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('정보를 가져오지 못했습니다.'),
          );
        }
        // 로딩 중일 때 화면
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final schedules = snapshot.data!.docs
            .map(
              (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
              json: (e.data() as Map<String, dynamic>)),
        )
            .toList();
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return Dismissible(
              key: ObjectKey(schedule.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (DismissDirection direction) {
                FirebaseFirestore.instance
                    .collection('schedule')
                    .doc(schedule.id)
                    .delete();
              },
              child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 12.0, right: 12.0),
                  child: ScheduleCard(
                    id: schedule.id,
                    scheduleName: schedule.scheduleName,
                    selectedDate: schedule.selectedDate,
                    startTime: schedule.startTime,
                    endTime: schedule.endTime,
                    memo: schedule.memo,
                    selectedColor: schedule.selectedColor,
                    isDone : schedule.isDone,
                  )),
            );
          },
        );
      },
    );
  }
}
