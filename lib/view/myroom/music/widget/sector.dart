import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/common/const/colors.dart';

class Sector extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final IconData iconData;
  const Sector({super.key, this.onTap, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:30.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // 양 끝에 배치
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(iconData, size: 16, color: WHITE),
                  const SizedBox(width: 8),
                  Text(
                   title,
                    style: TextStyle(fontSize: 16, color: WHITE),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: WHITE,
            ),
          ],
        ),
      ),
    );
  }
}
