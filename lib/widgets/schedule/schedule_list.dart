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
    final query = Supabase.instance.client
        .from('schedule')
        .select('*')
        .filter('start_date', 'lte', '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}')
        .filter('end_date', 'gte', '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}');
        // .stream(primaryKey: ['id'])
        // .eq('start_date',
        //     '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}');

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: query.asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print('정보 불러오기 에러 $snapshot.hasError.toString()');
          return Center(
            child: Text('잠시 후 다시 시도해 주세요.'),
          );
        }
        // 로딩 중일 때 화면
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Container();
        }
        final schedules = snapshot.data!
            .map(
              (e) => ScheduleModel.fromJson(json: e),
            )
            .toList();

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
                    startDate: schedule.startDate,
                    endDate: schedule.endDate,
                    startTime: schedule.startTime,
                    endTime: schedule.endTime,
                    memo: schedule.memo,
                    sectionColor: schedule.sectionColor,
                  )),
            );
          },
        );
      },
    );
  }
}
