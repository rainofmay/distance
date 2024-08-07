import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/glass_morphism.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CustomDialog({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TRANSPARENT,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: GlassMorphism(
        blur: 1,
        opacity: 0.65,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(children: [
            Positioned.fill(
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: WHITE),
                                ),
                                // 세부 설정
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: children,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
            Positioned(
              // 하단에 버튼 고정
              bottom: 0,
              left: 0,
              right: 0,
              child: OkCancelButtons(
                okText: '확인',
                cancelText: '취소',
                onPressed: () {
                  Navigator.of(context).pop(); // 닫히는 버튼
                },
                onCancelPressed: () {
                  Navigator.of(context).pop(); // 닫히는 버튼
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}