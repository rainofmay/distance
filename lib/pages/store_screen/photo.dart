import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Photo extends StatefulWidget {
  const Photo({super.key});

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  final Set<List<dynamic>> _photoThemes = {
    ['바다', Icon(CupertinoIcons.gift_fill), Container()],
    ['숲', Icon(CupertinoIcons.gift_fill), Container()],
    ['공원', Icon(CupertinoIcons.gift_fill), Container()],
    ['공부', Icon(CupertinoIcons.gift_fill), Container()],
    ['도시', Icon(CupertinoIcons.gift_fill), Container()],
    ['캠핑', Icon(CupertinoIcons.gift_fill), Container()],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8.0, // 버튼 사이의 간격
              runSpacing: 8.0, // 줄 간의 간격
              children: List.generate(_photoThemes.length, (index) {
                final themeLists = _photoThemes.toList();
                return SizedBox(
                  width:
                      (MediaQuery.of(context).size.width - 8 * 2 - 8 * 4) / 5,
                  // 8*2는 양옆padding, 8*4는 4개의 간격(한 줄에 5개 이므로)
                  child: TextButton(
                    onPressed: () {},
                    child: Text(themeLists[index][0]),
                  ),
                );
              }),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // maxCrossAxisExtent: MediaQuery.of(context).size.width - 8 * 2,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2, // 가로, 세로 비율
                ),
                itemCount: 12,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                    ),

                    child: Text('뒷배경'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
