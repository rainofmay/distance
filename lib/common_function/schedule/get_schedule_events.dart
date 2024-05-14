import 'package:supabase_flutter/supabase_flutter.dart';

import '../../util/schedule_events_provider.dart';

getScheduleEvents(context) async {
  final snapshot = await Supabase.instance.client.from('schedule').select();
  final List<dynamic> newData = snapshot
      .map((data) =>
  [DateTime.parse(data['start_date']).toUtc().add(Duration(hours: 9)), DateTime.parse(data['end_date']).toUtc().add(Duration(hours: 9)), data['id']])
  // toUtc는 DateTime에 z값 삽입하기 위함. 9시간을 더하는 것은 한국 표준시에 맞추기 위해
      .toList();

  if (!context.mounted) return;
  context.read<ScheduleEventsProvider>().addEvents(newData);
}