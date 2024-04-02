import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController maxMembersController = TextEditingController();
    TextEditingController studyTimeController = TextEditingController();

    final picker = ImagePicker();
    DateTime selectedDate = DateTime.now();
    DateTime nowTime = DateTime.now();
    //현재 값으로 설정한 것이지, 이게 최종 값은 아니다. 최종 값으로는 설정한 날로 해줄 것.
    File? image;
    List<XFile?> multiImage = [];
    List<XFile?> images = [];
    late int dDay;
    String dDayString = "";

    return Scaffold(
      appBar: AppBar(
        titleSpacing: -10,
        backgroundColor: BLACK,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: WHITE,
          ),
        ),
        title: Text(
          '클래스룸 생성',
          style: TextStyle(fontSize: 16, color: WHITE),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "그룹 이름"),
            ),
            SizedBox(
              height: 23.0, // 높이를 조절하여 간격을 만듭니다.
            ),
            Text("디데이 설정",
                style: TextStyle(
                  fontSize: 18,
                )),
            SizedBox(
              height: 20.0, // 높이를 조절하여 간격을 만듭니다.
            ),
            SizedBox(
                width: 250,
                height: 100,
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime date) {
                      setState(() {
                        selectedDate = date;
                        dDay = DateTime(
                              nowTime.year,
                              // DateTime 안에서 year, month, day 값을 받아온 뒤
                              nowTime.month,
                              nowTime.day,
                            ).difference(selectedDate).inDays +
                            1;
                        if (dDay >= 0) {
                          dDayString = '+ $dDay';
                        } else {
                          dDayString = '$dDay';
                        }
                      });
                    })),
            SizedBox(
              height: 16.0, // 높이를 조절하여 간격을 만듭니다.
            ),
            Text(
              'D-DAY: ${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(
              height: 16.0, // 높이를 조절하여 간격을 만듭니다.
            ),
            Text('D$dDayString'),
            // 사진 image_picker로 수정
            Text(
              "스터디룸 사진 설정",
              style: TextStyle(fontSize: 20),
            ),

            image == null
                ? Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          if (pickedFile != null) {
                            image = File(pickedFile.path);
                            print("image File Path : $image");
                          }
                        });
                      },
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(image.path)),
                      ),
                    ),
                  ),
            TextFormField(
              controller: maxMembersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "최대 인원 수"),
            ),
            // 주요 공부시간대 설정
            TextFormField(
              controller: studyTimeController,
              decoration: InputDecoration(labelText: "주요 공부 시간"),
            ),
            // 추가로 뭘 더 들어가야 할지 설정
            BorderLine(lineHeight: 10),
            OkCancelButtons(
              okText: '생성',
              cancelText: '취소',
              onPressed: () {
                Navigator.of(context).pop();
                // CreateGroup 함수 호출
                _createGroup(
                  nameController.text,
                  int.tryParse(maxMembersController.text) ?? 0,
                  studyTimeController.text,
                );
              },
              onCancelPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  image = null;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void _createGroup(String name, int maxMembers, String studyTime) {
    // 그룹 생성 로직을 여기에 구현
    print('Creating group with: $name, $maxMembers, $studyTime');
  }
}
