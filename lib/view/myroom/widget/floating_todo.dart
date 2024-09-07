import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FloatingTodo extends StatefulWidget {
  const FloatingTodo({super.key});

  @override
  State<FloatingTodo> createState() => _FloatingTodoState();
}

class _FloatingTodoState extends State<FloatingTodo> {
  double positionX = 100; // 위젯의 x 좌표
  double positionY = 100; // 위젯의 y 좌표
  double width = 300; // 위젯의 너비
  double height = 400; // 위젯의 높이
  Offset _startTopLeftOffset = Offset(0, 0); // 좌상단 모서리의 시작 오프셋
  Offset _startTopRightOffset = Offset(0, 0); // 우상단 모서리의 시작 오프셋
  Offset _startBottomLeftOffset = Offset(0, 0); // 좌하단 모서리의 시작 오프셋
  Offset _startBottomRightOffset = Offset(0, 0); // 우하단 모서리의 시작 오프셋
  bool _isResizingTopLeft = false; // 좌상단 모서리 크기 조절 여부
  bool _isResizingTopRight = false; // 우상단 모서리 크기 조절 여부
  bool _isResizingBottomLeft = false; // 좌하단 모서리 크기 조절 여부
  bool _isResizingBottomRight = false; // 우하단 모서리 크기 조절 여부
  bool _isDraggingAppBar = false; // 상단 바 드래그 여부
  Offset _startDragOffset = Offset(0, 0); // 상단 바 드래그 시작 오프셋
  double minWidth = 150; // 최소 너비
  double minHeight = 100; // 최소 높이
  MyroomViewModel myroomViewModel = Get.find<MyroomViewModel>();
  ScheduleViewModel scheduleViewModel = Get.find<ScheduleViewModel>();
  bool isEmojiVisible = false;
  // 상단 바 드래그 여부를 설정하는 함수

  @override
  void initState() {
    super.initState();
    _loadPositionAndSize();
  }

  Future<void> _loadPositionAndSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      positionX = prefs.getDouble('floatingTodoPositionX') ?? 100;
      positionY = prefs.getDouble('floatingTodoPositionY') ?? 100;
      width = prefs.getDouble('floatingTodoWidth') ?? 300;
      height = prefs.getDouble('floatingTodoHeight') ?? 400;
    });
  }

  Future<void> _savePositionAndSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('floatingTodoPositionX', positionX);
    await prefs.setDouble('floatingTodoPositionY', positionY);
    await prefs.setDouble('floatingTodoWidth', width);
    await prefs.setDouble('floatingTodoHeight', height);
  }


  void _setDraggingAppBar(bool value) {
    setState(() {
      _isDraggingAppBar = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: positionX,
          top: positionY,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: WHITE.withOpacity(0.9),
              border: Border(
                top: BorderSide(
                  color: BLACK.withOpacity(0.9), // 테두리 색상
                  width: 8.0, // 테두리 굵기
                ),
              ),
            ),
            width: width,
            height: height,
            child: Stack(
              children: [Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onPanStart: (details) {
                      // 상단 바 드래그 시작 시 초기화
                      if (details.localPosition.dy <= 30) {
                        _isDraggingAppBar = true;
                        _startDragOffset = details.localPosition;
                      }
                    },
                    onPanUpdate: (details) {
                      if (_isDraggingAppBar) {
                        setState(() {
                          double dx =
                              details.localPosition.dx - _startDragOffset.dx;
                          double dy =
                              details.localPosition.dy - _startDragOffset.dy;
                          positionX += dx;
                          positionY += dy;
                          _startDragOffset = details.localPosition;
                        });
                      }
                    },
                    onPanEnd: (details) {
                      // 상단 바 드래그 종료 시 초기화
                      _savePositionAndSize(); // 위치와 크기 저장
                      _isDraggingAppBar = false;
                    },
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      color: TRANSPARENT,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Text(
                              'TODAY',
                              style: TextStyle(
                                  color: DARK,
                                  fontSize: 13,
                                  fontFamily: 'GmarketSansTTFMedium'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() =>
                    scheduleViewModel.todaySchedules.isNotEmpty ? ListView
                        .builder(
                      itemCount: scheduleViewModel.todaySchedules.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            _optionsDialog(scheduleViewModel.todaySchedules[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Container(
                                      width: 5,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: sectionColors[
                                          scheduleViewModel
                                              .todaySchedules[index]
                                              .sectionColor],
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        scheduleViewModel
                                            .todaySchedules[index]
                                            .scheduleName,
                                        style: scheduleViewModel
                                            .todaySchedules[index].isDone ? TextStyle(
                                            color: sectionColors[
                                            scheduleViewModel
                                                .todaySchedules[index]
                                                .sectionColor],
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                            decoration: TextDecoration.lineThrough,
                                            decorationColor: sectionColors[
                                            scheduleViewModel
                                                .todaySchedules[index]
                                                .sectionColor]
                                        ) : TextStyle(
                                            color: sectionColors[
                                            scheduleViewModel
                                                .todaySchedules[index]
                                                .sectionColor],
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(height: 6),
                                      scheduleViewModel.todaySchedules[index].memo != '' ? Text(
                                          '# ${scheduleViewModel.todaySchedules[index].memo}',
                                          style: const TextStyle(
                                              color: BLACK,
                                              fontSize: 13,
                                              overflow: TextOverflow.ellipsis)) : const SizedBox(),
                                      const SizedBox(height: 6),
                                      scheduleViewModel
                                          .todaySchedules[index].isTimeSet
                                          ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, right: 8.0),
                                        child: Text(
                                          '${DateFormat('hh:mm a').format(
                                              scheduleViewModel.todaySchedules[index]
                                                  .startDate)}~${DateFormat('hh:mm a')
                                              .format(
                                              scheduleViewModel.todaySchedules[index]
                                                  .endDate)}',
                                          style: TextStyle(
                                              fontSize: 8, color: GREY),
                                        ),
                                      )
                                          : SizedBox(),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ) : Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Text('오늘 일정이 없습니다.',
                          style: TextStyle(fontSize: 13, color: DARK)),
                    )),
                  ),
                ],
              ), Positioned(
                  top: 8,
                  right: 4,
                  child: GestureDetector(
                      onTap: () {
                        myroomViewModel.updateSimpleWindowChange(false);
                      },
                      child: const Icon(Icons.cancel_rounded, size: 16))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onPanStart: (details) {
            // myroomViewModel.setScheduleTrash(true);
            // 시작 시, 현재 위젯의 좌표와 크기를 계산합니다.
            double left = positionX;
            double top = positionY;
            double right = positionX + width;
            double bottom = positionY + height;
            double touchRadius = 20; // 터치 반경을 정의합니다.

            // 상단 바를 제외한 영역에서는 크기 조절을 시작합니다.

            if ((details.localPosition.dx - left).abs() <= touchRadius &&
                (details.localPosition.dy - top).abs() <= touchRadius) {
              _startTopLeftOffset = details.localPosition; // 시작 오프셋을 설정합니다.
              _isResizingTopLeft = true; // 좌상단 모서리 크기 조절을 시작합니다.
            }
            // 우상단 모서리
            else if ((details.localPosition.dx - right).abs() <= touchRadius &&
                (details.localPosition.dy - top).abs() <= touchRadius) {
              _startTopRightOffset = details.localPosition; // 시작 오프셋을 설정합니다.
              _isResizingTopRight = true; // 우상단 모서리 크기 조절을 시작합니다.
            }

            // 좌하단 모서리
            else if ((details.localPosition.dx - left).abs() <= touchRadius &&
                (details.localPosition.dy - bottom).abs() <= touchRadius) {
              _startBottomLeftOffset = details.localPosition; // 시작 오프셋을 설정합니다.
              _isResizingBottomLeft = true; // 좌하단 모서리 크기 조절을 시작합니다.
            }
            // 우하단 모서리
            else if ((details.localPosition.dx - right).abs() <= touchRadius &&
                (details.localPosition.dy - bottom).abs() <= touchRadius) {
              _startBottomRightOffset = details.localPosition; // 시작 오프셋을 설정합니다.
              _isResizingBottomRight = true; // 우하단 모서리 크기 조절을 시작합니다.
            } else if ((details.localPosition.dy - top).abs() <= 30) {
              _isDraggingAppBar = true;
              _startDragOffset = details.localPosition;
              print("Dragging..");
            }
          },
          onPanUpdate: (details) {
            // 드래그 중일 때

            setState(() {
              // 상단 바 드래그 중일 때
              if (_isDraggingAppBar) {
                setState(() {
                  double dx = details.localPosition.dx - _startDragOffset.dx;
                  double dy = details.localPosition.dy - _startDragOffset.dy;
                  positionX += dx;
                  positionY += dy;
                  _startDragOffset = details.localPosition;
                });
              }
              // 좌상단 모서리 크기 조절
              if (_isResizingTopLeft) {
                double dx = details.localPosition.dx - _startTopLeftOffset.dx;
                double dy = details.localPosition.dy - _startTopLeftOffset.dy;
                width -= dx;
                height -= dy;
                positionX += dx;
                positionY += dy;
                if (width < minWidth) {
                  positionX += width - minWidth;
                  width = minWidth;
                }
                if (height < minHeight) {
                  positionY += height - minHeight;
                  height = minHeight;
                }
                _startTopLeftOffset = details.localPosition;
              }
              // 우상단 모서리 크기 조절
              else if (_isResizingTopRight) {
                double dx = details.localPosition.dx - _startTopRightOffset.dx;
                double dy = details.localPosition.dy - _startTopRightOffset.dy;
                width += dx;
                height -= dy;
                positionY += dy;
                if (width < minWidth) width = minWidth;
                if (height < minHeight) {
                  positionY += height - minHeight;
                  height = minHeight;
                }
                _startTopRightOffset = details.localPosition;
              }

              // 좌하단 모서리 크기 조절
              else if (_isResizingBottomLeft) {
                double dx =
                    details.localPosition.dx - _startBottomLeftOffset.dx;
                double dy =
                    details.localPosition.dy - _startBottomLeftOffset.dy;
                width -= dx;
                height += dy;
                positionX += dx;
                if (width < minWidth) {
                  positionX += width - minWidth;
                  width = minWidth;
                }
                if (height < minHeight) height = minHeight;
                _startBottomLeftOffset = details.localPosition;
              }
              // 우하단 모서리 크기 조절
              else if (_isResizingBottomRight) {
                double dx =
                    details.localPosition.dx - _startBottomRightOffset.dx;
                double dy =
                    details.localPosition.dy - _startBottomRightOffset.dy;
                width += dx;
                height += dy;
                if (width < minWidth) width = minWidth;
                if (height < minHeight) height = minHeight;
                _startBottomRightOffset = details.localPosition;
              }
            });
          },
          onPanEnd: (details) {
            // 드래그 종료 시, 크기 조절 상태를 초기화합니다.
            _isResizingTopLeft = false;
            _isResizingTopRight = false;
            _isResizingBottomLeft = false;
            _isResizingBottomRight = false;
            _setDraggingAppBar(false); // 상단 바를 드래그 중이 아니도록 설정합니다.
            _savePositionAndSize(); // 위치와 크기 저장

          },
        ),
      ],
    );
  }

  _optionsDialog(ScheduleModel schedule) {
    return showDialog(context: context, builder: (context) {
      return Center(child: Container(
          decoration: BoxDecoration(
            color: DARK_BACKGROUND,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 180,
          height: 120,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async{
                      await scheduleViewModel.toggleScheduleCompletion(schedule);
                      if(!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Text(schedule.isDone ? '진행으로 변경' : '완료로 변경', style: const TextStyle(color: WHITE))),
                const SizedBox(height: 28),
                GestureDetector(
                    onTap: () async {
                      await scheduleViewModel.deleteSchedule(schedule, false);
                      if(!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Text('일정에서 완전 삭제', style: TextStyle(color: WHITE))),
              ]
          )));
    },);
  }
}