import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view/schedule/create_schedule_screen.dart';
import 'package:mobile/view/schedule/widget/schedule/calendar.dart';
import 'package:mobile/view/schedule/widget/schedule/schedule_list.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({super.key});

  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));
  final List<String> _months = [
    'Jan',
    'Fab',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appbarTitle: '일 정',
        backgroundColor: DARK_BACKGROUND,
        contentColor: PRIMARY_COLOR,
        titleSpacing: 20,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 5),

              // 달력 큰제목
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 10, right: 40),
                child: Text(
                  _months[DateTime.now().month - 1],
                  style: const TextStyle(
                      color: BLACK, letterSpacing: 10, fontSize: 18),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 15, right: 43),
                child: Text(
                  '${DateTime.now().day}'.length == 2
                      ? '${DateTime.now().day}'
                      : '0 ${DateTime.now().day}',
                  style: const TextStyle(
                    color: BLACK,
                    letterSpacing: 6,
                    fontSize: 14,
                  ),
                ),
              ),
              Obx(
                    () => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (details) {
                    final double delta = details.primaryDelta ?? 0;
                    if (delta > 0) {
                      viewModel.updateCalendarFormatToMonth();
                    } else if (delta < 0) {
                      viewModel.updateCalendarFormatToWeek();
                    }
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.only(
                              top: 20, left: 30, right: 30),
                          child: Calendar(viewModel: viewModel)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left:8),
                        child: GestureDetector(
                          onTap: () {
                            pressed() {
                              viewModel.initializeForNewSchedule();
                              Get.to(() => CreateScheduleScreen(), preventDuplicates: true);
                            }
                            AuthHelper.navigateToLoginScreen(
                                context, pressed);
                          },
                          child: ListTile(
                            horizontalTitleGap: 0,
                            leading: Image.asset(
                              'assets/images/add_icon.png',
                              width: 17,
                              height: 17,
                            ),
                            title: Row(
                              children: [
                                // const SizedBox(width: 5),
                                Text(
                                    viewModel.calendarInfo.selectedDate.day ==
                                        DateTime.now().day
                                        ? '오늘'
                                        : '${viewModel.calendarInfo.selectedDate.month}월 ${viewModel.calendarInfo.selectedDate.day}일',
                                    style: const TextStyle(
                                        color: BLACK,
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ScheduleList(viewModel: viewModel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
