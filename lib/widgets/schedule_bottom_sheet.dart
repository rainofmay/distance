import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/schedule_custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  // final DateTime selectedDate;
  // final int? scheduleId;

  const ScheduleBottomSheet({super.key});

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
                height: MediaQuery.of(context).size.height * 0.6 + bottomInset,
                color: WHITE,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: '일정 이름',
                            isTime: false,
                          ),
                        ),
                        Row(
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
                                label: '종료 시간',
                                isTime: true,
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: CustomTextField(
                            label: '내용',
                            isTime: false,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          // height: 30,
                          margin: EdgeInsets.only(top:20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text('Cancel', style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.of(context).pop(); // 닫히는 버튼
                                },
                              ),
                              TextButton(
                                onPressed: onSavePressed,
                                child: Text('Ok', style: TextStyle(color: Color(0xff0029F5)),),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
    ),)));}


void onSavePressed() {

}
}