import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final String imageUrl;
  final int id;
  final void Function() onButtonPressed; // 수정된 부분

  CustomIconButton({super.key, required this.imageUrl, required this.id, required this.onButtonPressed});

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
              height: 290,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
