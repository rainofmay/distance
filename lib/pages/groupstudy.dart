import 'package:flutter/material.dart';

void main() {
  runApp(GroupStudy());
}

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
    'Group Study 1',
    'Group Study 2',
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
            return AddGroupButton(onPressed: () {
              _showCreateGroupDialog(context);
            });
          } else {
            return GroupStudyCard(
              name: groupStudyNames[index],
              onPressed: () {
                // 실행될 함수 호출
                print('Pressed ${groupStudyNames[index]}');
              },
              imageAsset: 'assets/images/backgroundtest1.jpeg',
            );
          }
        },
      ),
    );
  }

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    TextEditingController maxMembersController = TextEditingController();
    TextEditingController studyTimeController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("그룹 생성"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "그룹 이름"),
                ),
                TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: "사진 URL"),
                ),
                TextFormField(
                  controller: maxMembersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "최대 인원 수"),
                ),
                TextFormField(
                  controller: studyTimeController,
                  decoration: InputDecoration(labelText: "주요 공부 시간"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // CreateGroup 함수 호출
                _createGroup(
                  nameController.text,
                  imageUrlController.text,
                  int.tryParse(maxMembersController.text) ?? 0,
                  studyTimeController.text,
                );
              },
              child: Text("생성"),
            ),
          ],
        );
      },
    );
  }

  void _createGroup(String name, String imageUrl, int maxMembers, String studyTime) {
    // 그룹 생성 로직을 여기에 구현
    print('Creating group with: $name, $imageUrl, $maxMembers, $studyTime');
  }
}

class GroupStudyCard extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final String imageAsset;

  GroupStudyCard({required this.name, required this.onPressed, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              height: 199.0, // Adjust height as needed
            ),
          ],
        ),
      ),
    );
  }
}

class AddGroupButton extends StatelessWidget {
  final VoidCallback onPressed;

  AddGroupButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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
