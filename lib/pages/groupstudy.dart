import 'package:flutter/material.dart';

class GroupStudy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GroupStudyScreen(),
    );
  }
}

class GroupStudyScreen extends StatelessWidget {
  final List<String> groupStudyNames = [
    '토익',
    '토플',
    '코딩',
    // Add more group study names as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('그룹스터디'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: groupStudyNames.length + 1, // +1 for "그룹 생성하기" 버튼
        itemBuilder: (BuildContext context, int index) {
          if (index == groupStudyNames.length) {
            return AddGroupButton();
          } else {
            return GroupStudyCard(
              name: groupStudyNames[index],
              onPressed: () {
                // 실행될 함수 호출
                print('Pressed ${groupStudyNames[index]}');
              },
              imageAsset: 'assets/images/cafe1.jpeg',
            );
          }
        },
      ),
    );
  }
}

class GroupStudyCard extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final String imageAsset;

  GroupStudyCard({super.key, required this.name, required this.onPressed, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.black, width: 0.5),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class AddGroupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // "그룹 생성하기" 버튼이 눌렸을 때 실행되는 함수
        print('Create Group');
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: Icon(
            Icons.add,
            size: 40.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
