import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/widgets/schedule/schedule_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleList extends StatelessWidget {
  final selectedDate;

  const ScheduleList({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final stream = Supabase.instance.client
        .from('schedule')
        .stream(primaryKey: ['id'])
        .eq('selected_date',
        '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}');
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('정보를 가져오지 못했습니다.'),
          );
        }
        // 로딩 중일 때 화면
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return Container();
        }
        final schedules =snapshot.data!.map((e) => ScheduleModel.fromJson(json: e),).toList();

        return ListView.builder(
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return Dismissible(
              key: ObjectKey(schedule.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (DismissDirection direction) async {
                await Supabase.instance.client.from('schedule').delete().match({
                  'id': schedule.id,
                });
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
                    sectionColor: schedule.sectionColor,
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
