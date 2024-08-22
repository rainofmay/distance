import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
          appbarTitle: '앱 업데이트 공지',
          isLeading: true,
          isCenterTitle: true,
          backgroundColor: WHITE,
          contentColor: BLACK),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          children: [
            SizedBox(height: 16),
            Row(
            children: [
              Text('v 1.0.0.'),
              SizedBox(width: 16),
              Text('Distance 모바일 앱 출시')
            ],
          ),],
        ),
      ),
    );
  }
}
