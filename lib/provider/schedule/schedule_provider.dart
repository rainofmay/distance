import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleProvider {
  static final supabase = Supabase.instance.client;

  String? get _userId => AuthHelper.getCurrentUserId();

  /* Get */
  Future<List<Map<String, dynamic>>> getAllScheduleData() async {
    if (_userId == null){
      return [];
    }else{
      final response = await supabase
          .from('schedule')
          .select()
          .eq('uid', _userId!)
          .order('created_at', ascending: false);
      return response;
    }

  }

  Future<ScheduleModel> getScheduleById(String id) async {
    if (_userId == null) throw Exception('User not authenticated');
    final response = await supabase
        .from('schedule')
        .select()
        .eq('id', id)
        .eq('uid', _userId!)
        .single();
    return ScheduleModel.fromJson(json: response);
  }

  Future<List<ScheduleModel>> getSchedulesByGroupId(String groupId) async {
    if (_userId == null) throw Exception('User not authenticated');
    final response = await supabase
        .from('schedule')
        .select()
        .eq('group_id', groupId)
        .eq('uid', _userId!)
        .order('start_date', ascending: true);
    return response.map<ScheduleModel>((json) => ScheduleModel.fromJson(json: json)).toList();
  }

  /* Create */
  Future createScheduleData(ScheduleModel scheduleModel) async {
    if (_userId == null) throw Exception('User not authenticated');
    try {
      await supabase.from('schedule').insert({
        ...scheduleModel.toJson(),
        'uid': _userId!,
      });
    } catch (error) {
      print('Schedule Add 에러 $error');
    }
  }

  /* Update */
  Future editScheduleData(ScheduleModel schedule) async {
    if (_userId == null) throw Exception('User not authenticated');
    try {
      await supabase
          .from('schedule')
          .update(schedule.toJson())
          .eq('id', schedule.id)
          .eq('uid', _userId!);
    } catch (error) {
      print('에러 $error');
    }
  }

  /* Delete */
  Future deleteScheduleData(String id) async {
    if (_userId == null) throw Exception('User not authenticated');
    try {
      await supabase
          .from('schedule')
          .delete()
          .match({'id': id, 'uid': _userId!});
    } catch (error) {
      print('에러 $error');
    }
  }

  Future deleteScheduleGroup(String groupId) async {
    if (_userId == null) throw Exception('User not authenticated');
    try {
      await supabase
          .from('schedule')
          .delete()
          .eq('group_id', groupId)
          .eq('uid', _userId!);
    } catch (error) {
      print('Error deleting schedule group: $error');
    }
  }

  Future<void> deleteSchedulesAfterDate(String groupId, DateTime date) async {
    if (_userId == null) throw Exception('User not authenticated');
    await supabase
        .from('schedule')
        .delete()
        .eq('group_id', groupId)
        .eq('uid', _userId!)
        .gte('start_date', date.toIso8601String());
  }

  Future<void> deleteSchedulesExceptOne(String groupId, String exceptId) async {
    if (_userId == null) throw Exception('User not authenticated');
    await supabase
        .from('schedule')
        .delete()
        .eq('group_id', groupId)
        .eq('uid', _userId!)
        .neq('id', exceptId);
  }
}