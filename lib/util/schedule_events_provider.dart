import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleEventsProvider extends ChangeNotifier {
  List<dynamic> eventsLists = [];

  getScheduleEvents() async {
    final snapshot = await Supabase.instance.client.from('schedule').select();
    final List<dynamic> newData = snapshot
        .map((data) => [
              DateTime.parse(data['start_date'])
                  .toUtc()
                  .add(Duration(hours: 9)),
              DateTime.parse(data['end_date']).toUtc().add(Duration(hours: 9)),
              data['id'],
              data['section_color'],
            ])
        // toUtc는 DateTime에 z값 삽입하기 위함. 9시간을 더하는 것은 한국 표준시에 맞추기 위해
        .toList();
    eventsLists = newData;
    notifyListeners();
  }
}
