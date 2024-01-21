import 'package:flutter/material.dart';
import 'package:mobile/util/backgroundProvider.dart';
import 'package:provider/provider.dart';

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



  /*
  *     Provider.of<BackgroundProvider>(context, listen: false).selectedImageURL =
    backgroundProvider.imageURLs[selectedCategoryIndex][selectedIndex];
    Provider.of<BackgroundProvider>(context, listen: false).selectedIndex =
        selectedIndex;
        * 더 수정해야함 ㅠ*/
  @override
  Widget build(BuildContext context) {
    final backgroundProvider = context.read<BackgroundProvider>();

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
