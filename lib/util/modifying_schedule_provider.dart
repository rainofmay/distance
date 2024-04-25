import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/model/schedule_model.dart';
class ModifyingScheduleProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  var modifyingName;
  var modifyingColor;
  var modifyingMemo;
  var modifyingStartDate;
  var modifyingEndDate;
  var modifyingStartTime;
  var modifyingEndTime;
  var modifyingIsTimeSet;

  setModyfingId (newId) async {
    String id = newId;
    var uploadSchedule = await supabase.from('schedule').select().eq('id', id);
    print(uploadSchedule);
    modifyingName = ScheduleModel.fromJson(json: uploadSchedule[0]).scheduleName;
    modifyingColor = ScheduleModel.fromJson(json: uploadSchedule[0]).sectionColor;
    modifyingMemo = ScheduleModel.fromJson(json: uploadSchedule[0]).memo;
    modifyingStartDate = ScheduleModel.fromJson(json: uploadSchedule[0]).startDate;
    modifyingEndDate = ScheduleModel.fromJson(json: uploadSchedule[0]).endDate;
    modifyingStartTime = ScheduleModel.fromJson(json: uploadSchedule[0]).startTime;
    modifyingEndTime = ScheduleModel.fromJson(json: uploadSchedule[0]).endTime;
    modifyingIsTimeSet = ScheduleModel.fromJson(json: uploadSchedule[0]).isTimeSet;
    print(modifyingName);
    notifyListeners();
  }

}

