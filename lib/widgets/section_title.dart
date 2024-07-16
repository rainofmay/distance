import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Color? textColor = WHITE;
  final void Function()? onTap;

  SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // 클릭하면 해당 플레이리스트 세부 수록곡 보여주는 화면으로 이동
      onTap: onTap,
      child: Row(
        children: [
          Text(title,
              style: TextStyle(color: textColor ?? WHITE, fontSize: 12)),
          const SizedBox(width: 16),
          Expanded(child: Container(color: WHITE.withOpacity(0.3), height: 1))
        ],
      ),
    );
  }
}
