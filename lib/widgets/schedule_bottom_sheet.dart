import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/schedule_custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  // final DateTime selectedDate;
  // final int? scheduleId;

  const ScheduleBottomSheet({
    // required this.selectedDate,
    // this.scheduleId,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  // 위젯을 고유하게 식별하는 키
  // final GlobalKey<FormState> formKey = GlobalKey();

  // int? startTime;
  // int? endTime;
  // String? content;
  // int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                color: WHITE,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: '시작 시간',
                            isTime: true,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: CustomTextField(
                            label: '마감 시간',
                            isTime: true,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            label: '내용',
                            isTime: false,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onSavePressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CALENDAR_COLOR,
                            ),
                            child: Text('저장'),
                          ),
                        ),
                      ],
                    ),
    ),)));}


void onSavePressed() {

}
}