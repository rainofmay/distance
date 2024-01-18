import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final String imageUrl;
  final int id;
  final Function(int) onButtonPressed;

  CustomIconButton({required this.imageUrl, required this.id, required this.onButtonPressed});

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          //코드 추가 필요할 듯

          widget.onButtonPressed(widget.id); // 클릭된 버튼의 ID를 전달
          print(widget.id);
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
              height: 340,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
