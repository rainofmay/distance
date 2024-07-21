import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/widget/schedule/schedule_form.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_check_box.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';


class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({super.key});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));

  final _formKey = GlobalKey<FormState>();

  bool isAllDelete = false;

  chooseDeleteOption() {
    setState(() {
      isAllDelete = !isAllDelete;
    });
  }

  void _onSavePressed() async {
    if (_formKey.currentState!.validate() && viewModel.isFormValid) {
      _formKey.currentState!.save();
      // await viewModel.updateSchedule();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: WHITE,
          appBar: CustomBackAppBar(
            isLeading: true,
            appbarTitle: '',
            backFunction: () => Get.back(),
            backgroundColor: BLACK,
            contentColor: WHITE,
            isCenterTitle: false,
            actions: [
              ValueListenableBuilder(
                valueListenable: viewModel.titleController,
                builder: (BuildContext context, TextEditingValue value,
                    Widget? child) {
                  return TextButton(
                    onPressed: viewModel.isFormValid ? () => _onSavePressed() : null,
                    child: Text(
                      '수정',
                      style: TextStyle(color: viewModel.isFormValid ? WHITE : GREY),
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: () async {
                  viewModel.nowHandlingScheduleModel.repeatDays.contains(true)
                      ? customDialog(
                          context,
                          80,
                          '삭제',
                          Column(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: chooseDeleteOption(),
                                child: Row(
                                  children: [
                                    CustomCheckBox(
                                      value: !isAllDelete,
                                      radius: 10,
                                    ),
                                    Text('이 날짜의 일정만 삭제'),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: chooseDeleteOption(),
                                child: Row(
                                  children: [
                                    CustomCheckBox(
                                        value: isAllDelete, radius: 10),
                                    Text('반복된 일정 전부 삭제'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          OkCancelButtons(
                              okText: '확인',
                              cancelText: '취소',
                              onPressed: () async {
                                if (isAllDelete) {
                                  await viewModel.scheduleProvider
                                      .deleteScheduleData(
                                          viewModel.nowHandlingScheduleModel.id)
                                      .then((value) =>
                                          viewModel.updateAllSchedules());
                                } else {
                                  await viewModel.scheduleProvider
                                      .deleteScheduleData(
                                          viewModel.nowHandlingScheduleModel.id)
                                      .then((value) =>
                                          viewModel.updateAllSchedules());
                                }
                                // 이벤트 재랜더링과 연관 있는 기능들
                                viewModel
                                    .updateSelectedDate(viewModel.calendarInfo.selectedDate);
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              }),
                        )
                      : await viewModel.scheduleProvider
                          .deleteScheduleData(
                              viewModel.nowHandlingScheduleModel.id)
                          .then((value) => viewModel.updateAllSchedules());
                  viewModel.updateSelectedDate(viewModel.calendarInfo.selectedDate);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '삭제',
                  style: TextStyle(
                      color: Color(0xffff2200), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          body: SafeArea(
              child: Form(
            key: _formKey,
            child: ScheduleForm()
          )),
        ));
  }
}
