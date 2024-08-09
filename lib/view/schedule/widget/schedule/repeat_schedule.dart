import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/schedule/widget/schedule/omni_date_time_picker_theme.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/custom_text_field.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class RepeatScheduleWidget extends StatelessWidget {
  final viewModel = Get.find<ScheduleViewModel>();
  RepeatScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Obx(() => CustomTextField(
                autofocus: false,
                titleIcon: const IconButton(
                  icon: Icon(CupertinoIcons.repeat, color: Colors.black),
                  onPressed: null,
                ),
                readOnly: true,
                hint: viewModel.nowHandlingScheduleModel.repeatType,
              ),)
            ),
            Expanded(
              flex: 2,
              child: Obx(() => DropdownButton<String>(
                style: const TextStyle(fontSize: 16),
                dropdownColor: WHITE,
                icon: const Padding(
                  padding: EdgeInsets.only(bottom: 16.0, right: 20.0),
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ),
                iconSize: 24,
                isExpanded: true,
                underline: Container(height: 0),
                value: viewModel.nowHandlingScheduleModel.repeatType,
                onChanged: (String? newValue) {
                  viewModel.setRepeatType(newValue ?? "반복없음");
                },
                items: viewModel.repeatTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(value, style: const TextStyle(color: BLACK)),
                    ),
                  );
                }).toList(),
              ))
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (viewModel.nowHandlingScheduleModel.repeatType == '지정') ...[
                const SizedBox(height: 16),
                const Text('반복할 요일 선택', style: TextStyle(fontSize: 14, color: BLACK)),
                Wrap(
                  spacing: 5,
                  runSpacing: 8,
                  children: List.generate(7, (index) {
                    return FilterChip(
                      backgroundColor: WHITE,
                      selectedColor: DARK,
                      checkmarkColor: PRIMARY_COLOR,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      label: Text(['월', '화', '수', '목', '금', '토', '일'][index], style: TextStyle(color: viewModel.nowHandlingScheduleModel.repeatDays[index] == true ? PRIMARY_COLOR : DARK_UNSELECTED)),
                      selected: viewModel.nowHandlingScheduleModel.repeatDays[index],
                      onSelected: (bool selected) {
                        viewModel.setRepeatDay(index);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('반복 주기 ', style: TextStyle(color: BLACK, fontSize: 14)),
                    const SizedBox(width: 24),
                    DropdownButton<int>(
                      dropdownColor: WHITE,
                      value: viewModel.nowHandlingScheduleModel.repeatWeeks,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 18,
                      underline: Container(height: 0),
                      items: List.generate(12, (index) => index + 1).map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value주', style: const TextStyle(color: BLACK, fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        viewModel.setRepeatWeek(newValue);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final DateTime? picked = await showOmniDateTimePicker(
                        context: context,
                        theme: OmniDateTimePickerTheme.theme,
                        initialDate: viewModel.nowHandlingScheduleModel.repeatEndDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365 * 3)),
                        barrierDismissible: true,
                        type: OmniDateTimePickerType.date
                    );
                    if (picked != null && picked != viewModel.nowHandlingScheduleModel.repeatEndDate) {
                      viewModel.setRepeatEndDate(picked);
                    }
                  },
                  child: Row(
                    children: [
                      Text('반복 종료일 : ${viewModel.nowHandlingScheduleModel.repeatEndDate.toString().split(' ')[0]}'),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 2.0),
                        child: Icon(CupertinoIcons.calendar, size: 20)
                      )
                    ],
                  ),
                ),
              ],
            ],
          ),)
        )
      ],
    );
  }
}