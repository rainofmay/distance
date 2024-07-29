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
            controller.updateQuote();
          },
          child: Draggable(
            feedback: _buildQuoteContainer(context),
            childWhenDragging: Opacity(
              opacity: 0.1,
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
                      controller.currentQuote.value.quote,
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
                      "- ${controller.currentQuote.value.writer}",
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
