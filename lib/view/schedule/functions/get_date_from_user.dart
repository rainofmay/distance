import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/view/schedule/widget/schedule/omni_date_time_picker_theme.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

Future<void> getDateFromUser(
    {required BuildContext context, required bool isStartTime, required ScheduleViewModel viewModel}) async {
  DateTime? pickerDate = await showOmniDateTimePicker(
    context: context,
    theme: OmniDateTimePickerTheme.theme,
    initialDate: isStartTime ? viewModel.nowHandlingScheduleModel.startDate : viewModel.nowHandlingScheduleModel.endDate,
    type: viewModel.nowHandlingScheduleModel.isTimeSet
        ? OmniDateTimePickerType.dateAndTime
        : OmniDateTimePickerType.date,
    firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
    lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
    is24HourMode: false,
    isShowSeconds: false,
    minutesInterval: 5,
    // secondsInterval: 1,
    isForce2Digits: true,
    borderRadius: const BorderRadius.all(Radius.circular(1)),
    constraints: const BoxConstraints(
      maxWidth: 350,
      maxHeight: 700,
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1.drive(
          Tween(
            begin: 0,
            end: 1,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
  );

  if (pickerDate != null) {
    if (isStartTime) {
      viewModel.setStartDate(pickerDate);
    } else {
      viewModel.setEndDate(pickerDate);
    }
  } else {
    // 사용자가 선택을 취소한 경우, 기존 날짜를 유지
    pickerDate = isStartTime
        ? viewModel.nowHandlingScheduleModel.startDate
        : viewModel.nowHandlingScheduleModel.endDate;
  }

  viewModel.updateFormValidity();

}