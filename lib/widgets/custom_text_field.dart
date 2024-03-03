import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final String? hint;
  final TextEditingController? controller;
  final Widget? widget;
  final int? maxiLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.onSaved,
    this.validator,
    this.hint,
    this.controller,
    this.widget,
    this.maxiLines
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(left: 28, bottom: 10),
            child: Text(label, style: TextStyle(fontSize: 12, fontFamily: 'GmarketSansTTFMedium', color: Colors.grey),)),
        Row(
          children: [
            Expanded(
                // flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 40),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    readOnly: widget == null ? false : true,
                    controller: controller,
                    onSaved: onSaved,
                    validator: validator,
                    cursorColor: Colors.grey,
                    maxLines: maxiLines,
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: hint,
                      labelStyle: TextStyle(color: Colors.black38),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: CALENDAR_COLOR)),
                      suffixIcon: widget == null // 필드 끝단에 아이콘 배치
                          ? null
                          : Container(
                        child: widget,
                      )
                    ),
                  ),
                )),

          ],
        )
      ],
    );
  }
}
