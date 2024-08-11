import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';

class SoundCopyright extends StatelessWidget {
  const SoundCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
          appbarTitle: 'Copyright',
          isLeading: true,
          isCenterTitle: true,
          backgroundColor: WHITE,
          contentColor: BLACK),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('(C) 2022, JICA (출처 : 전주정보문화산업진흥원)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('산_소요산_선녀탕_수원지', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            const Text('새_참새_가평 청평면_수리재 마을 들깨밭에서 우는 맑은 소리',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            const Text('산_산_가평 연인산_명품길 계곡 상류의 졸졸거리는 물소리',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            const Text('주택가_남태령_' '비닐하우스 비떨어지는 소리 외부',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            const Text('섬_선유도 몽돌해변_암벽 가까운 밀물 파도',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            const Text('공원_인천 소래습지공원_천둥치고바람불고 소나기오는 소리',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 24),
            const Text('(C) 2020, 전주정보문화산업진흥원', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('생물_산_새소리', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
