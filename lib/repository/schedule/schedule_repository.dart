import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';

class ScheduleRepository {
  final ScheduleProvider _scheduleProvider;

  ScheduleRepository({
    required ScheduleProvider scheduleProvider,
  }) : _scheduleProvider = scheduleProvider;

  /* Get Schedule List */
  Future<List<ScheduleModel>> fetchAllScheduleData() async {
    try {
      var response = await _scheduleProvider.getAllScheduleData();
      final allScheduleData = response.map((e) {
        return ScheduleModel.fromJson(json: e);
      }).toList();
      print('allScheduleData $allScheduleData');
      return allScheduleData;
    } catch (e, stackTrace) {
      print('Error in fetchAllScheduleData: $e');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  Future<List<ScheduleModel>> fetchAllMateScheduleData(String mateId) async {
    try {
      var response = await _scheduleProvider.getMateSchedule(mateId);
      final mateScheduleData = response.map((e) {
        return ScheduleModel.fromJson(json: e);
      }).toList();
      print('mateScheduleData $mateScheduleData');
      return mateScheduleData;
    } catch (e, stackTrace) {
      print('Error in fetchAllMateScheduleData: $e');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

// Future<List<ScheduleModel>> fetchScehduleData(DateTime day) async {
//   var response = await _scheduleProvider.getScheduleData(day);
//   print('repository response $response');
//   final schedueleData =
//       response.map((e) => ScheduleModel.fromJson(json: e)).toList();
//   print('repository schedueleData $schedueleData');
//   return schedueleData;
// }
}
