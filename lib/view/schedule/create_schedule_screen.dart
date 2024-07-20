import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/functions/time_comarison.dart';
import 'package:mobile/view/schedule/widget/schedule/schedule_form.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';

import 'package:mobile/view_model/schedule/schedule_view_model.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));

  final _formKey = GlobalKey<FormState>();

  bool _isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _onSavePressed() async {
    if (_isFormValid()) {
      try {
        await viewModel.createSchedule();
        if (!mounted) return;
        Navigator.of(context).pop();
      } catch (error) {
        print('_onSavePressed 에러: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WHITE,
        appBar: CustomBackAppBar(
          isLeading: true,
          appbarTitle: '',
          isCenterTitle: true,
          backFunction: () => Navigator.of(context).pop(),
          backgroundColor: BLACK,
          contentColor: WHITE,
          actions: [
            Obx(() => TextButton(
              onPressed: viewModel.isFormValid ? _onSavePressed : null,
              child: Text(
                '저장',
                style: TextStyle(
                    color: viewModel.isFormValid ? PRIMARY_LIGHT : GREY
                ),
              ),
            ))
          ],
        ),
        body: SafeArea(
          child: Form(key: _formKey, child: ScheduleForm()),
        ));
  }
}
