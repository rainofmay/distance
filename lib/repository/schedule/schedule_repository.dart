import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';

class ScheduleRepository {
  final ScheduleProvider _scheduleProvider;

  ScheduleRepository({
    required ScheduleProvider scheduleProvider,
  }) : _scheduleProvider = scheduleProvider;

  /* Get Schedule List */
  Future<List<ScheduleModel>> fetchAllScheduleData() async {
    var response = await _scheduleProvider.getAllScheduleData();
    final allSchedueleData =
    response.map((e) => ScheduleModel.fromJson(json: e)).toList();
    return allSchedueleData;
  }


  Future<List<ScheduleModel>> fetchScehduleData(DateTime day) async {
    var response = await _scheduleProvider.getScheduleData(day);
    print('repository response $response');
    final schedueleData =
        response.map((e) => ScheduleModel.fromJson(json: e)).toList();
    print('repository schedueleData $schedueleData');
    return schedueleData;
  }
}
