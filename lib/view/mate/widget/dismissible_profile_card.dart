import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/profile_card.dart';
import 'package:mobile/view/mate/widget/profile_card.dart';

class DismissibleProfileCard extends StatelessWidget {
  final UserProfile profile; // Profile 객체
  final Function onDelete; // 삭제 로직을 위한 콜백 함수
  final int index; // 삭제할 Profile의 인덱스

  // 생성자를 통해 필요한 데이터와 함수를 초기화
  const DismissibleProfileCard({
    Key? key,
    required this.profile,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(profile.name), // 고유한 key 지정
      direction: DismissDirection.endToStart, // 오른쪽에서 왼쪽으로 스와이프
      onDismissed: (direction) {
        onDelete(index); // 실제 삭제 로직을 실행하는 콜백 함수 호출
      },
      confirmDismiss: (direction) async { // 삭제 전 확인 대화 상자
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("삭제 확인"),
              content: const Text("정말로 삭제하시겠습니까?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // 삭제 승인
                  child: const Text("삭제"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // 삭제 취소
                  child: const Text("취소"),
                ),
              ],
            );
          },
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: ProfileCard(profile: profile), // ProfileCard 위젯
    );
  }
}
