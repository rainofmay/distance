import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  final Color color;
  final Color? disabledColor; // 비활성화 시 아이콘 색상
  final String? tooltip; // 툴팁 텍스트
  final bool enabled;
  final EdgeInsetsGeometry? padding; // 아이콘 주변 패딩
  final BoxConstraints? constraints; // 아이콘 최대/최소 크기 제한
  final double? splashRadius; // 물결 효과 반경

  const CustomIconButton({
    super.key,
    required this.icon,
    this.size = 24.0, // 기본 크기 24
    required this.onPressed,
    this.color = Colors.black, // 기본 색상 검정
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding,
    this.constraints,
    this.splashRadius,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size,
      padding: padding ?? EdgeInsets.zero,
      constraints: constraints,
      splashRadius: splashRadius,
      icon: Icon(icon, color: enabled ? color : disabledColor),
      onPressed: enabled ? onPressed : null,
      tooltip: tooltip,
    );
  }
}
