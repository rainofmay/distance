import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/custom_alert_dialog.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class MotivationalQuote extends GetView<MyroomViewModel> {
  MotivationalQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isBackdropWordEnabled) return SizedBox.shrink();
      return Stack(
        children: [
          Positioned(
            left: controller.quotePosition.value.dx,
            top: controller.quotePosition.value.dy,
            child: GestureDetector(
              onTap: () {
                _showConfirmationDialog(context);
              },
              child: Draggable<String>(
                data: 'quote',
                feedback: _buildQuoteContainer(context),
                childWhenDragging: Opacity(
                  opacity: 0.1,
                  child: _buildQuoteContainer(context),
                ),
                onDragStarted: () {
                  controller.setTrash(true);
                },
                onDragEnd: (details) {
                  controller.setTrash(false);
                  controller.updateQuotePosition(details.offset);
                },
                child: _buildQuoteContainer(context),
              ),
            ),
          ),
          if (controller.showTrash)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: candidateData.isNotEmpty ? CUSTOMRED : GREY,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete, color: PRIMARY_COLOR, size: 24),
                    );
                  },

                  // onWillAcceptWithDetails: (data) => data == 'quote',
                  onAcceptWithDetails: (data) {
                    controller.updateBackdropWordChange(false);
                    controller.update();
                  },
                ),
              ),
            ),
        ],
      );
    });
  }


  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: '변경',
            width: 120,
            height: 30,
            contents: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('문구를 무작위로 변경하시겠어요?', style: TextStyle(color: WHITE)),
            ),
            actionWidget: OkCancelButtons(
                okText: '확인',
                okTextColor: PRIMARY_LIGHT,
                cancelText: '취소',
                onCancelPressed: () {
                  Navigator.of(context).pop();
                },
                onPressed: () {
                  controller.updateQuote();
                  Navigator.of(context).pop();
                }));
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
