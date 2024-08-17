import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/util/ads/adController.dart';
import 'package:mobile/view/schedule/widget/schedule/schedule_form.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';

class CreateScheduleScreen extends StatelessWidget {
  CreateScheduleScreen({super.key});

  final adController = Get.put(AdController());
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));


  bool _isFormValid() {
    return viewModel.formKey.currentState?.validate() ?? false;
  }

  void _onSavePressed(context) async {
    if (_isFormValid()) {
      try {
        await viewModel.createSchedule();
        Navigator.of(context).pop();
      } catch (error) {
        print('_onSavePressed 에러: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                  onPressed: () {
                    if (!context.mounted) return;
                    viewModel.isFormValid ? _onSavePressed(context) : null;
                  },
                  child: Text(
                    '저장',
                    style: TextStyle(
                        color: viewModel.isFormValid ? PRIMARY_LIGHT : GREY),
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Obx(() => Column(
                children: [
                  Form(key: viewModel.formKey, child: ScheduleForm()),
                  const SizedBox(height: 16),
                  if (adController.isAdLoaded.value &&
                      viewModel.nowHandlingScheduleModel.repeatType == '반복없음')
                    SizedBox(
                      height:
                          adController.bannerAd.value!.size.height.toDouble(),
                      child: AdWidget(ad: adController.bannerAd.value!),
                    ),
                ],
              )),
        ));
  }
}
