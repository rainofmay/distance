import 'package:flutter/material.dart';

import '../common/const/colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final Color? checkColor;
  final Color? activeColor;
  final Color? borderColor;
  const CustomCheckBox({super.key, required this.value, this.onChanged, this.checkColor, this.activeColor, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        splashRadius: 0,
        activeColor: activeColor ?? DARK,
        checkColor: checkColor ?? PRIMARY_COLOR,
        hoverColor: TRANSPARENT,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor ?? BLACK),
        ),
        value: value,
        onChanged: onChanged);
  }
}