import 'package:flutter/material.dart';
import 'package:mobile/widgets/borderline.dart';
import '../../../common/const/colors.dart';
import '../../../widgets/appBar/custom_back_appbar.dart';

class ScheduleBackgroundSetting extends StatefulWidget {
  const ScheduleBackgroundSetting({super.key});

  @override
  State<ScheduleBackgroundSetting> createState() =>
      _ScheduleBackgroundSettingState();
}

class _ScheduleBackgroundSettingState extends State<ScheduleBackgroundSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '배경 설정',
        backFunction: Navigator.of(context).pop,
        backgroundColor: BLACK,
        contentColor: WHITE,
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BorderLine(lineHeight: 20, lineColor: TRANSPARENT),
              // 미리보기 그림.
              Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                                    'assets/images/test.png',
                                    width: 130,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                  )),
              const BorderLine(lineHeight: 10, lineColor: TRANSPARENT),
              const Text('미리보기', style: TextStyle(fontSize: 15)),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            '추천 배경',
                            style: TextStyle(fontSize: 17),
                          )),
                    ),
                  ),
                  BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            '내 갤러리에서 가져오기',
                            style: TextStyle(fontSize: 17),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Dark & Light 모드',
                            style: TextStyle(fontSize: 17),
                          )),
                    ),
                  ),
                  BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
