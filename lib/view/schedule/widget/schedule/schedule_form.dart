
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/mate/widget/custom_dialog.dart';
import 'package:mobile/view/schedule/functions/get_date_from_user.dart';
import 'package:mobile/view/schedule/widget/schedule/color_selection.dart';
import 'package:mobile/view/schedule/widget/schedule/repeat_schedule.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/custom_text_field.dart';
import 'package:mobile/widgets/tapable_row.dart';

class ScheduleForm extends StatelessWidget {
  ScheduleForm({super.key});

  final ScheduleViewModel viewModel = Get.find<ScheduleViewModel>();

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Padding(
        padding:
        // appBar와 body 간의 간격
        EdgeInsets.only(
          left: 8.0,
          top: 16.0,
        ),
        child: Obx(() => Column(
          children: [
            CustomTextField(
              autofocus: false,
              textInputAction: TextInputAction.done,
              readOnly: false,
              controller: viewModel.titleController,
              titleIcon: IconButton(
                  icon: Icon(CupertinoIcons.circle_filled,
                      color: viewModel.selectedSectionColor),
                  onPressed: () => customDialog(
                    context,
                    240,
                    '구분 색상',
                    Column(children: [
                      ColorSelection(scheduleViewModel: viewModel)
                    ]),
                    TextButton(
                      child: Text('확인',
                          style: TextStyle(color: WHITE)),
                      onPressed: () {
                        // _sectionColor = viewModel.colorIndex;
                        Navigator.of(context).pop();
                      },
                    ),
                  )),
              hint: '일정을 입력해 주세요.',
              hintStyle: TextStyle(color: Colors.grey[350]),
              maxLines: 1,
              maxLength: 60,
              onChanged: (_) => viewModel.updateFormValidity(),
              onSaved: (val) {
                var scheduleName = val as String;
                viewModel.setScheduleName(scheduleName);
              },
            ),
            CustomTextField(
              autofocus: false,
              textInputAction: TextInputAction.done,
              readOnly: false,
              controller: viewModel.memoController,
              titleIcon: IconButton(
                  icon: Icon(
                    Icons.sticky_note_2_outlined,
                    color: BLACK,
                  ),
                  onPressed: null),
              hint: '메모를 입력해 보세요.',
              hintStyle: TextStyle(color: Colors.grey[350]),
              maxLines: 1,
              maxLength: 200,
              validator: (value) {
                if (value != null && value.length > 200) {
                  return '메모는 200자를 초과할 수 없습니다.';
                }
                return null;
              },
              onChanged: (_) => viewModel.updateFormValidity(),
              // onChanged: (val) {
              //   viewModel.setScheduleName(val);
              // },
              // onSaved: (val) {
              //   setState(() {
              //     var memo = val as String;
              //     viewModel.setScheduleName(memo);
              //   });
              // },
            ),

            // 시작 일시
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    autofocus: false,
                    readOnly: true,
                    onTap: () {
                      getDateFromUser(
                          context: context, isStartTime: true, viewModel: viewModel);
                    },
                    titleIcon: IconButton(
                        icon: Icon(
                          Icons.edit_calendar_outlined,
                          color: BLACK,
                        ),
                        onPressed: null),
                    hint: DateFormat.yMd().format(viewModel.nowHandlingScheduleModel.startDate),
                  ),
                ),
                viewModel.nowHandlingScheduleModel.isTimeSet
                    ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: CustomTextField(
                        onTap: () {
                          getDateFromUser(
                              context: context, isStartTime: true, viewModel: viewModel);
                        },
                        autofocus: false,
                        textAlign: TextAlign.right,
                        readOnly: true,
                        hint: DateFormat('hh:mm a').format(viewModel.nowHandlingScheduleModel.startDate),
                      ),
                    ))
                    : const SizedBox(),
              ],
            ),

            // 종료 일시
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    autofocus: false,
                    readOnly: true,
                    onTap: () {
                      getDateFromUser(
                          context: context, isStartTime: false, viewModel: viewModel);
                    },
                    titleIcon: IconButton(
                        icon: Icon(
                          Icons.edit_calendar_outlined,
                          color: TRANSPARENT,
                        ),
                        onPressed: null),
                    hint: DateFormat.yMd().format(viewModel.nowHandlingScheduleModel.endDate),
                    hintStyle: viewModel.nowHandlingScheduleModel.endDate.isBefore(viewModel.nowHandlingScheduleModel.startDate)
                        ? TextStyle(color: RED)
                        : TextStyle(),
                  ),
                ),
                viewModel.nowHandlingScheduleModel.isTimeSet
                    ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: CustomTextField(
                        onTap: () {
                          getDateFromUser(
                              context: context, isStartTime: false, viewModel: viewModel);
                        },
                        autofocus: false,
                        textAlign: TextAlign.right,
                        readOnly: true,
                        hint: DateFormat('hh:mm a').format(viewModel.nowHandlingScheduleModel.endDate),
                        hintStyle: viewModel.nowHandlingScheduleModel.endDate.isBefore(viewModel.nowHandlingScheduleModel.startDate) || viewModel.nowHandlingScheduleModel.endDate.isAtSameMomentAs(viewModel.nowHandlingScheduleModel.startDate)
                            ? TextStyle(color: RED)
                            : TextStyle(),
                      ),
                    ))
                    : const SizedBox(),
              ],
            ),

            Obx(() {
              if (!viewModel.isFormValid) {
                String errorMessage = '';
                if (viewModel.nowHandlingScheduleModel.repeatType == '지정') {
                  if (!DateUtils.isSameDay(viewModel.nowHandlingScheduleModel.startDate, viewModel.nowHandlingScheduleModel.endDate)) {
                    errorMessage = '반복기능을 쓰실 경우, 시작일과 종료일이 같아야 합니다.';
                  } else if (!viewModel.nowHandlingScheduleModel.repeatDays[viewModel.nowHandlingScheduleModel.startDate.weekday - 1]) {
                    errorMessage = '시작일이 반복할 요일과 일치해야 합니다.';
                  }
                }
                return errorMessage.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
                    : SizedBox.shrink();
              } else {
                return SizedBox.shrink();
              }
            }),

            Padding(
              padding: const EdgeInsets.only(right: 13.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Time'),
                  const SizedBox(width: 3),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: viewModel.nowHandlingScheduleModel.isTimeSet,
                      activeColor: Color(0xff8FB8EE),
                      //Color(0xffC8D8FA)
                      onChanged: (bool? value) {
                        viewModel.toggleTimeSet();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 완료 여부
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Row(
                children: [
                  // Icon
                  TapableRow(
                      widget: viewModel
                          .nowHandlingScheduleModel.isDone
                          ? Padding(
                        padding: const EdgeInsets.only(right:16.0),
                        child: Icon(Icons.check_box_rounded),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(right:16.0),
                        child: Icon(
                            Icons.check_box_outline_blank_rounded),
                      ),
                      title: viewModel.nowHandlingScheduleModel.isDone
                          ? '일정 완료'
                          : '일정 진행',
                      onTap: () {
                        viewModel.setIsDone(!viewModel
                            .nowHandlingScheduleModel.isDone);
                      }),
                ],
              ),
            ),

            RepeatScheduleWidget(),
          ],
        )),
      ),
    );
  }
}
