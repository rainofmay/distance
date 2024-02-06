import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/widgets/schedule/schedule_card.dart';

class Todos extends StatefulWidget {
  final selectedDate;

  const Todos({super.key, required this.selectedDate});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController introduceController = TextEditingController();
  List<Map<String, dynamic>> todoList = [];
  String? _error; //_err


  void _deleteTodo(int index) {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('todo')
          .where(
            '날짜',
            isEqualTo:
                '${widget.selectedDate.year}${widget.selectedDate.month.toString().padLeft(2, '0')}${widget.selectedDate.day.toString().padLeft(2, '0')}',
          )
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
            print(schedule.isDone);



            return Dismissible(
              key: ObjectKey(schedule.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (DismissDirection direction) {
                FirebaseFirestore.instance
                    .collection('todo')
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
