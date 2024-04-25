import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/pages/schedule_screen/schedule/create_schedule.dart';
import 'package:mobile/widgets/schedule/schedule_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleList extends StatefulWidget {
  final selectedDate;

  const ScheduleList({super.key, required this.selectedDate});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  List scheduleList = []; // Drift DB에 저장하는 코드 작성 필요
  Future<List<Map<String, dynamic>>> futureData() async {
    var future = Supabase.instance.client
        .from('schedule')
        .select('*')
    // stream을 쓰면 lte와 gte 동시에 사용 불가
        .lte('start_date',
        '${widget.selectedDate.year}${widget.selectedDate.month.toString().padLeft(2, '0')}${widget.selectedDate.day.toString().padLeft(2, '0')}')
        .gte('end_date',
        '${widget.selectedDate.year}${widget.selectedDate.month.toString().padLeft(2, '0')}${widget.selectedDate.day.toString().padLeft(2, '0')}');

    return future;
  }

  @override
  Widget build(BuildContext context) {
    // var stream = Supabase.instance.client
    //     .from('schedule')
    //     .stream(primaryKey: ['id'])
    //     .gte('end_date',
    //         '${widget.selectedDate.year}${widget.selectedDate.month.toString().padLeft(2, '0')}${widget.selectedDate.day.toString().padLeft(2, '0')}');

    // && greaterThanOrEqual(event, 'end_date', selectedDateString)

    //     .select('*')
    //     .lte('start_date',
    //     '${widget.selectedDate.year}${widget.selectedDate.month.toString()
    //         .padLeft(
    //         2, '0')}${widget.selectedDate.day.toString().padLeft(2, '0')}')
    //
    //     .gte('end_date',
    //     '${widget.selectedDate.year}${widget.selectedDate.month.toString()
    //         .padLeft(
    //         2, '0')}${widget.selectedDate.day.toString().padLeft(2, '0')}').asStream();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print('정보 불러오기 에러 $snapshot.hasError.toString()');
          return const Center(
            child: Text('잠시 후 다시 시도해 주세요.'),
          );
        }
        // 로딩 중일 때 화면
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Container();
        }
        final schedules =
            snapshot.data!.map((e) => ScheduleModel.fromJson(json: e)).toList();

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
                    isTimeSet: schedule.isTimeSet,
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
