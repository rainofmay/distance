import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';

class ColorSelection extends StatelessWidget {
  final ScheduleViewModel scheduleViewModel;
  ColorSelection({super.key, required this.scheduleViewModel});



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 240,
      height: 200,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(), // 터치 스크롤현상 없애는 것.
        // scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: sectionColors.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          //1 개의 행에 보여줄 item 개수
          childAspectRatio: 1.8,
          //item 의 가로 1, 세로 1 의 비율
          mainAxisSpacing: 20, // 세로 간격
          crossAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Obx(() => GestureDetector(
            onTap: () {
              scheduleViewModel.setSectionColorIndex(index);
            },
            child: CircleAvatar(
                backgroundColor: sectionColors[index],
                child: scheduleViewModel.nowHandlingScheduleModel.sectionColor == index
                    ? Icon(
                  Icons.check_rounded,
                  color: WHITE,
                  size: 19,
                )
                    : null),
          ));
        },
      ),
    );
  }
}
