import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';

class MotivationalQuote extends GetView<MyroomViewModel> {
  MotivationalQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        left: controller.quotePosition.value.dx,
        top: controller.quotePosition.value.dy,
        child: GestureDetector(
          onTap: () {
            _showConfirmationDialog(context);
          },
          child: Draggable(
            feedback: _buildQuoteContainer(context),
            childWhenDragging: Opacity(
              opacity: 0.1,
              child: _buildQuoteContainer(context),
            ),
            onDragEnd: (details) {
              controller.updateQuotePosition(details.offset);
            },
            child: _buildQuoteContainer(context),
          ),
        ),
      );
    });
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('인용문 변경'),
          content: Text('인용문을 랜덤으로 변경하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                controller.updateQuote();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuoteContainer(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = MediaQuery.of(context).size.width * 0.85;
        return Obx(() {
          return Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: controller.quoteBackdropColor.value,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => Text(
                  controller.currentQuote.quote,
                  style: TextStyle(
                    color: controller.quoteFontColor.value,
                    fontSize: controller.quoteFontSize.value,
                    fontWeight: FontWeight.bold,
                    fontFamily: controller.quoteFont.value,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 8),
                Obx(() => Text(
                  "- ${controller.currentQuote.writer}",
                  style: TextStyle(
                    color: controller.quoteFontColor.value,
                    fontSize: controller.quoteFontSize.value - 4,
                    fontStyle: FontStyle.italic,
                    fontFamily: controller.quoteFont.value,
                  ),
                  textAlign: TextAlign.right,
                )),
              ],
            ),
          );
        });
      },
    );
  }
}