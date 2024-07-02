import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/util/responsiveStyle.dart';
import 'package:mobile/view/myroom/widget/custom_dialog.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
class StatusManageOnline extends StatelessWidget {
  final MateViewModel viewModel = Get.find<MateViewModel>(); // Get the ViewModel instance
  StatusManageOnline({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(title: "상태 지정", children: [
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)
        ),
        width: MediaQuery
            .of(context)
            .size
            .width * 0.5,
        child: Column(
          children: [
            onlieStatusRow(context,"온라인", Colors.green, OnlineStatus.online,false),
            onlieStatusRow(context,"오프라인", Colors.grey, OnlineStatus.offline,false),
            onlieStatusRow(context,"자리 비움", Colors.yellow, OnlineStatus.away,false),
            onlieStatusRow(context,"방해 금지", Colors.red, OnlineStatus.dnd,true),
          ],
        ),
      ),
    ]);

  }
  Widget onlieStatusRow(BuildContext context, String label, Color color, OnlineStatus status, bool isLast) {
    double fontSize = getResponsiveFontSize(context);
    double circleRadius = getResponsiveCircleRadius(context);

    return Column(
      children: [
        InkWell( // Use InkWell for a more elegant tap effect
          onTap: () {
            viewModel.onTapOnlineStatus(status); // Update the status in the ViewModel
            Navigator.pop(context); // Close the dialog
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(radius: circleRadius, backgroundColor: color),
                const SizedBox(width: 40),
                Text(label, style: TextStyle(fontSize: fontSize, color: Colors.white)),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1, thickness: 1, color: Colors.white),
      ],
    );
  }
}

