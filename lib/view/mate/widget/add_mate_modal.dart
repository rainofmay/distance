// 메이트 추가 모달창을 보여주는 함수
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void ShowAddMateDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = ''; // 사용자로부터 입력받은 이메일을 저장할 변수
        return AlertDialog(
          title: Text('메이트 추가'),
          content: TextField(
            onChanged: (value) {
              email = value; // 입력 필드에 입력된 값을 email 변수에 저장
            },
            decoration: InputDecoration(hintText: "메이트의 이메일을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                // 여기에 메이트 추가 로직을 구현할 수 있습니다.
                // 예를 들어, profiles 리스트에 새로운 UserProfile 인스턴스를 추가하는 코드를 넣을 수 있습니다.
              },
              child: Text('추가'),
            ),
          ],
        );
      });
}