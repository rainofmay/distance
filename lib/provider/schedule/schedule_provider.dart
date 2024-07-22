import 'package:mobile/model/schedule_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleProvider {
  static final supabase = Supabase.instance.client;

  /* Get */
  Future<List<Map<String, dynamic>>> getAllScheduleData() async {
    final response = await supabase.from('schedule').select();
    return response;
  }

  Future<List<Map<String, dynamic>>> getScheduleData(DateTime day) async {
    final response = await supabase
        .from('schedule')
        .select()
        .lte('start_date',
        '${day.year}${day.month.toString().padLeft(2, '0')}${day.day.toString()
            .padLeft(2, '0')}')
        .gte('end_date',
    '${day.year}${day.month.toString().padLeft(2, '0')}${day.day.toString()
        .padLeft(2, '0')}');
    return response;
  }

  /* Create */
  Future createScheduleData(ScheduleModel scheduleModel) async {
    try {
      await supabase.from('schedule').insert(scheduleModel.toJson());
    } catch (error) {
      print('Schedule Add 에러 $error');
    }
  }

  /* Update */
  Future editScheduleData(ScheduleModel schedule) async {
    try {
      await supabase.from('schedule').update(
          schedule.toJson()).eq('id', schedule.id);
    } catch (error) {
      print('에러 $error');
    }
  }

  /* Delete */
  Future deleteScheduleData(String id) async {
    try {
      await supabase.from('schedule').delete().match({
        'id': id});
    } catch (error) {
      print('에러 $error');
    }
  }

  Future deleteScheduleGroup(String groupId) async {
    try {
      await supabase.from('schedule').delete().eq('group_id', groupId);
    } catch (error) {
      print('Error deleting schedule group: $error');
    }
  }
}
