import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view/etc/personal_information.dart';
import 'package:mobile/view/etc/update_notification.dart';
import 'package:mobile/view/payment/payment_screen.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/tapable_row.dart';

import '../../common/const/colors.dart';

class Etc extends StatefulWidget {
  Etc({super.key});
  final MateViewModel viewModel = Get.find<MateViewModel>(); // Get the ViewModel instance

  @override
  State<Etc> createState() => _EtcState();
}

class _EtcState extends State<Etc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
          appbarTitle: '더보기',
          backgroundColor: TRANSPARENT,
          contentColor: BLACK,
          isCenterTitle: false,
          titleSpacing: 15),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: WHITE,
                      backgroundImage:
                          AssetImage('assets/images/themes/gomzy_theme.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Text(widget.viewModel.name.value)
                  ],
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      overlayColor: TRANSPARENT,
                      shadowColor: TRANSPARENT,
                      backgroundColor: WHITE,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: BLACK),
                          borderRadius: BorderRadius.circular(20))),
                  child: Text('Log out',
                      style: TextStyle(fontSize: 10, color: BLACK)),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 구독 프리미엄
          GestureDetector(
              child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(color: BLACK),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('「프리미엄 Distance」 이용하기',
                          style: TextStyle(color: WHITE)),
                      Text('1개월 무료 체험', style: TextStyle(color: WHITE)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentScreen()),
                          )
                        },
                    // Navigate using GetX
                    icon: Icon(Icons.arrow_forward_ios),
                    color: WHITE),
              ],
            ),
          )),
          const SizedBox(height: 15),

          TapableRow(
            widget: Icon(CupertinoIcons.lock),
            title: '내 정보 관리',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => PersonalInformation()));
            },
          ),

          const SizedBox(height: 15),
          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 15),

          TapableRow(
            widget: Icon(CupertinoIcons.speaker_1),
            title: '앱 업데이트 공지',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => UpdateNotification()));
            },
          ),

          const SizedBox(height: 15),
          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 15),

          TapableRow(
            widget: Icon(Icons.notifications_none_rounded),
            title: '알림',
            onTap: () {},
          ),

          const SizedBox(height: 15),
          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
