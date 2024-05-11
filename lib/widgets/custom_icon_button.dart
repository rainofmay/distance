import 'package:flutter/material.dart';
import 'package:mobile/util/background_provider.dart';
import 'package:provider/provider.dart';

import '../const/colors.dart';

class CustomIconButton extends StatefulWidget {
  final String imageUrl;
  final int id;
  final int selectedCategoryIndex;
  final int selectedIndex; // 새로운 매개변수 추가
  final bool isImage;
  final bool isSelected; // 새로운 isSelected 속성

  CustomIconButton({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.selectedCategoryIndex,
    required this.selectedIndex,
    required this.isImage,// 생성자에 추가
    required this.isSelected, // 추가된 isSelected 속성
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {

  @override
  Widget build(BuildContext context) {
    final backgroundProvider = context.read<BackgroundProvider>();
    return GestureDetector(
      onTap: () {
          backgroundProvider.selectedCategoryIndex = widget.selectedCategoryIndex;
          backgroundProvider.selectedIndex = widget.selectedIndex;
          backgroundProvider.isImage = widget.isImage;
          print("Custom_icon_button Category_Index: ${widget.selectedCategoryIndex}");
          print("Custom_icon_button Index:${widget.selectedIndex}");
          print("Custom_icon_button ${widget.isImage}");
          print("-------------------------------------");
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isSelected ? Colors.purple : TRANSPARENT,
            width: widget.isSelected ? 2.5 : 1.0
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: BLACK,
                width: 1.0,
              ),
            ),
            child: Image(
              image: AssetImage(widget.imageUrl),
              width: 125,
              height: 165,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
