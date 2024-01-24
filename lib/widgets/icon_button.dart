import 'package:flutter/material.dart';
import 'package:mobile/util/background_provider.dart';
import 'package:provider/provider.dart';

class CustomIconButton extends StatefulWidget {
  final String imageUrl;
  final int id;
  final void Function() onButtonPressed;
  final int selectedCategoryIndex;
  final int selectedIndex; // 새로운 매개변수 추가

  CustomIconButton({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.onButtonPressed,
    required this.selectedCategoryIndex,
    required this.selectedIndex, // 생성자에 추가
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final backgroundProvider = context.read<BackgroundProvider>();

    return GestureDetector(
      onTap: () {
        setState(() {
          // 사용 예시: widget.selectedCategoryIndex, widget.selectedIndex
          backgroundProvider.selectedIndex = widget.selectedIndex;
          backgroundProvider.selectedCategoryIndex = widget.selectedCategoryIndex;
          print(widget.selectedCategoryIndex);
          print(widget.selectedIndex);
        });
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Image(
              image: AssetImage(widget.imageUrl),
              width: 150,
              height: 290,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}