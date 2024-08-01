import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/widget/schedule/schedule_form.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';


class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({super.key});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));

  bool isAllDelete = false;

  chooseDeleteOption() {
    setState(() {
      isAllDelete = !isAllDelete;
    });
  }

  void _onSavePressed() async {
    if (viewModel.formKey.currentState!.validate() && viewModel.isFormValid) {
      viewModel.formKey.currentState!.save();
      await viewModel.editSchedule();

      if(!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,
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
                    onPressed:
                        viewModel.isFormValid ? () => _onSavePressed() : null,
                    child: Text(
                      '수정',
                      style: TextStyle(
                          color: viewModel.isFormValid ? WHITE : GREY),
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  if (viewModel.nowHandlingScheduleModel.repeatType == '지정') {
                    showDeleteOptionDialog(
                        context, viewModel.nowHandlingScheduleModel);
                  } else {
                    viewModel.deleteSchedule(
                        viewModel.nowHandlingScheduleModel, false);
                    Navigator.of(context).pop();
                  }
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
                  key: viewModel.formKey,
                  child: ScheduleForm())),
        ));
  }

  void showDeleteOptionDialog(BuildContext context, ScheduleModel schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BLACK,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          title: Text('일정 삭제', style: TextStyle(color: WHITE, fontSize: 17)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: Text('반복되는 모든 일정 삭제',
                    style: TextStyle(color: WHITE, fontSize: 15)),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  viewModel.deleteSchedule(schedule, true);
                  Navigator.of(context).pop(); // EditScheduleScreen 닫기
                },
              ),
              TextButton(
                child: Text('이 일정만 삭제',
                    style: TextStyle(color: WHITE, fontSize: 15)),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  viewModel.deleteSchedule(schedule, false);
                  Navigator.of(context).pop(); // EditScheduleScreen 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
