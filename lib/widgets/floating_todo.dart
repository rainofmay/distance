import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/background_setting_provider.dart';

class FloatingTodo extends StatefulWidget {
  const FloatingTodo({Key? key}) : super(key: key);

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
  List<String> incompleteTasks = ['Task 1', 'Task 2', 'Task 3']; // 미완료 작업 목록
  double minWidth = 150; // 최소 너비
  double minHeight = 100; // 최소 높이

  @override
  Widget build(BuildContext context) {
    var backgroundSettingProvider = Provider.of<BackgroundSettingProvider>(context);
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
                Container(
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
                          setState(() {
                            backgroundSettingProvider.updateSimpleWindowEnabled(false);

                            // 위젯 삭제
                            // 부모 위젯의 목록에서 삭제해야 할 수도 있음
                          });
                        },
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
            double left = positionX;
            double top = positionY;
            double right = positionX + width;
            double bottom = positionY + height;
            double touchRadius = 20;
            //rePosiion 함수도 만들어야 하는 상태...
            if ((details.localPosition.dx - left).abs() <= touchRadius &&
                (details.localPosition.dy - top).abs() <= touchRadius) {
              _startTopLeftOffset = details.localPosition;
              _isResizingTopLeft = true;
            } else if ((details.localPosition.dx - right).abs() <= touchRadius &&
                (details.localPosition.dy - top).abs() <= touchRadius) {
              _startTopRightOffset = details.localPosition;
              _isResizingTopRight = true;
            } else if ((details.localPosition.dx - left).abs() <= touchRadius &&
                (details.localPosition.dy - bottom).abs() <= touchRadius) {
              _startBottomLeftOffset = details.localPosition;
              _isResizingBottomLeft = true;
            } else if ((details.localPosition.dx - right).abs() <= touchRadius &&
                (details.localPosition.dy - bottom).abs() <= touchRadius) {
              _startBottomRightOffset = details.localPosition;
              _isResizingBottomRight = true;
            }
          },
          onPanUpdate: (details) {
            setState(() {
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
              } else if (_isResizingTopRight) {
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
              } else if (_isResizingBottomLeft) {
                double dx = details.localPosition.dx - _startBottomLeftOffset.dx;
                double dy = details.localPosition.dy - _startBottomLeftOffset.dy;
                width -= dx;
                height += dy;
                positionX += dx;
                if (width < minWidth) {
                  positionX += width - minWidth;
                  width = minWidth;
                }
                if (height < minHeight) height = minHeight;
                _startBottomLeftOffset = details.localPosition;
              } else if (_isResizingBottomRight) {
                double dx = details.localPosition.dx - _startBottomRightOffset.dx;
                double dy = details.localPosition.dy - _startBottomRightOffset.dy;
                width += dx;
                height += dy;
                if (width < minWidth) width = minWidth;
                if (height < minHeight) height = minHeight;
                _startBottomRightOffset = details.localPosition;
              }
            });
          },
          onPanEnd: (details) {
            _isResizingTopLeft = false;
            _isResizingTopRight = false;
            _isResizingBottomLeft = false;
            _isResizingBottomRight = false;
          },
        ),
      ],
    );
  }
}
