import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view/schedule/create_schedule_screen.dart';
import 'package:mobile/view/schedule/widget/schedule/calendar.dart';
import 'package:mobile/view/schedule/widget/schedule/schedule_list.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appbarTitle: '일 정',
        backgroundColor: WHITE,
        contentColor: BLACK,
        titleSpacing: 25,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => CreateScheduleScreen());
              },
              icon: const Icon(CupertinoIcons.add_circled_solid),
              color: SECONDARY),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 달력 큰제목
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 15, right: 40),
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
            Expanded(
                child: Obx(
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
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: viewModel.isCalendarVisible == true
                          ? Calendar(viewModel: viewModel)
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListTile(
                        horizontalTitleGap: 3,
                        leading: IconButton(
                            onPressed: () {
                              viewModel.updateCalendarVisible();
                            },
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                            ),
                            color: BLACK,
                            highlightColor: TRANSPARENT,
                            splashColor: TRANSPARENT),
                        title: Text(
                            viewModel.selectedDate.day == DateTime.now().day
                                ? '오늘'
                                : '${viewModel.selectedDate.month}월 ${viewModel.selectedDate.day}일',
                            style: const TextStyle(
                                color: BLACK,
                                fontWeight: FontWeight.w100,
                                fontSize: 15)),
                      ),
                    ),
                    Expanded(child: ScheduleList(viewModel: viewModel)),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
