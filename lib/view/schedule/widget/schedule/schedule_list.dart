import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/view/schedule/edit_schedule_screen.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';

class ScheduleList extends StatelessWidget {
  final ScheduleViewModel viewModel;

  ScheduleList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Obx(() => viewModel.isScheduleListLoaded
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.selectedDateSchedules.length,
            itemBuilder: (BuildContext context, int index) {
              final schedule = viewModel.selectedDateSchedules[index];
              return scheduleCard(schedule, context);
            },
          )
        : Container());
  }

  Widget scheduleCard(ScheduleModel schedule, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 12.0, right: 12.0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque, // 빈 영역도 터치되도록

          // 수정 페이지 들어갈 때,
          onTap: () {
            viewModel.initializeForEditSchedule(schedule);
            Get.to(() => EditScheduleScreen(), preventDuplicates: true);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                child: Container(
                  width: 5,
                  height: 55,
                  decoration: BoxDecoration(
                      color: sectionColors[schedule.sectionColor],
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 30, left: 5, bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        // 카드 안에서 텍스트의 패딩 간격
                        left: 8,
                        right: 8,
                        top: 12,
                        bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(schedule.scheduleName,
                                style: schedule.isDone ? const TextStyle(
                                    fontSize: 15, color: BLACK, decoration: TextDecoration.lineThrough) : const TextStyle(
                                    fontSize: 15, color: BLACK)),
                            Text(
                              schedule.isTimeSet
                                  ? schedule.startDate.day !=
                                          schedule
                                              .endDate.day // 시간 설정 있고, 기간일 때
                                      ? schedule.startDate.year ==
                                              schedule.endDate.year
                                          ? '${schedule.startDate.year}/${schedule.startDate.month}/${schedule.startDate.day} ~ ${schedule.endDate.month}/${schedule.endDate.day}'
                                          : '${schedule.startDate.year}/${schedule.startDate.month}/${schedule.startDate.day} ~ ${schedule.endDate.year}/${schedule.endDate.month}/${schedule.endDate.day}'
                                      : '${DateFormat('hh:mm a').format(schedule.startDate)}~${DateFormat('hh:mm a').format(schedule.endDate)}' // 하루일 때

                                  : schedule.startDate.day !=
                                          schedule
                                              .endDate.day // 시간 설정 없고 기간일 때,
                                      ? schedule.startDate.year ==
                                              schedule.endDate.year
                                          ? '${schedule.startDate.year}/${schedule.startDate.month}/${schedule.startDate.day} ~ ${schedule.endDate.month}/${schedule.endDate.day}'
                                          : '${schedule.startDate.year}/${schedule.startDate.month}/${schedule.startDate.day} ~ ${schedule.endDate.year}/${schedule.endDate.month}/${schedule.endDate.day}'
                                      : '${schedule.startDate.year}/${schedule.startDate.month}/${schedule.startDate.day}',
                              style: const TextStyle(
                                  fontSize: 9, color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            alignment: Alignment.topLeft,
                            child: Text(schedule.memo != '' ? '# ${schedule.memo}' : schedule.memo,
                                style:
                                    const TextStyle(fontSize: 12, color: BLACK),
                                overflow: TextOverflow.ellipsis))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
