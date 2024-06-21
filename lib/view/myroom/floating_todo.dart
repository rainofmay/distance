import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/view_model/background/myroom_view_model.dart';

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
  List<String> incompleteTasks = ['Task 1', 'Task 2', 'Task 3']; // 미완료 작업 목록
  double minWidth = 150; // 최소 너비
  double minHeight = 100; // 최소 높이
  MyroomViewModel myroomViewModel = Get.put(MyroomViewModel());
  // 상단 바 드래그 여부를 설정하는 함수
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
            width: width,
            height: height,
            color: Colors.tealAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    // 상단 바 드래그 시작 시 초기화
                    if (details.localPosition.dy <= 30) {
                      _isDraggingAppBar = true;
                      _startDragOffset = details.localPosition;
                      print("Dragging..");
                    }
                  },
                  onPanUpdate: (details) {
                    if (_isDraggingAppBar) {
                      setState(() {
                        double dx = details.localPosition.dx - _startDragOffset.dx;
                        double dy = details.localPosition.dy - _startDragOffset.dy;
                        positionX += dx;
                        positionY += dy;
                        _startDragOffset = details.localPosition;
                      });
                    }
                  },
                  onPanEnd: (details) {
                    // 상단 바 드래그 종료 시 초기화
                    _isDraggingAppBar = false;
                  },
                  child: Container(
                    width: double.infinity,
                    height: 30,
                    color: Colors.teal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '미완료 작업',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              myroomViewModel
                                  .updateSimpleWindowChange(false);

                              // 위젯 삭제
                              // 부모 위젯의 목록에서 삭제해야 할 수도 있음
                            }
                          ,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: incompleteTasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          incompleteTasks[index],
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          // 작업 탭 처리
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onPanStart: (details) {
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
              else if ((details.localPosition.dx - right).abs() <=
                      touchRadius &&
                  (details.localPosition.dy - top).abs() <= touchRadius) {
                _startTopRightOffset = details.localPosition; // 시작 오프셋을 설정합니다.
                _isResizingTopRight = true; // 우상단 모서리 크기 조절을 시작합니다.
              }

              // 좌하단 모서리
              else if ((details.localPosition.dx - left).abs() <= touchRadius &&
                  (details.localPosition.dy - bottom).abs() <= touchRadius) {
                _startBottomLeftOffset =
                    details.localPosition; // 시작 오프셋을 설정합니다.
                _isResizingBottomLeft = true; // 좌하단 모서리 크기 조절을 시작합니다.
              }
              // 우하단 모서리
              else if ((details.localPosition.dx - right).abs() <=
                      touchRadius &&
                  (details.localPosition.dy - bottom).abs() <= touchRadius) {
                _startBottomRightOffset =
                    details.localPosition; // 시작 오프셋을 설정합니다.
                _isResizingBottomRight = true; // 우하단 모서리 크기 조절을 시작합니다.
              }else if((details.localPosition.dy - top).abs() <= 30){
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
                  double dx = details.localPosition.dx -
                      _startTopRightOffset.dx;
                  double dy = details.localPosition.dy -
                      _startTopRightOffset.dy;
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
          },
        ),
      ],
    );
  }
}
