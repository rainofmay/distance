import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class ColorSelection extends StatefulWidget {
  ColorSelection({super.key});

  @override
  State<ColorSelection> createState() => _ColorSelectionState();
}

class _ColorSelectionState extends State<ColorSelection> {
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: sectionColor.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        //1 개의 행에 보여줄 item 개수
        childAspectRatio: 5,
        //item 의 가로 1, 세로 1 의 비율
        mainAxisSpacing: 5,
      ),
      itemBuilder:
          (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = index;
            });
          },
          child: CircleAvatar(
              radius: 18,
              backgroundColor: sectionColor[index],
              child: _selectedColor == index ? Icon(
                Icons.check_rounded,
                color: WHITE,
                size: 16,
              ) : null),
        );
      },
    );
  }
}
