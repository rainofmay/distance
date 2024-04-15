import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Widget? titleIcon;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final String? hint;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.onTap,
    this.titleIcon,
    this.onSaved,
    this.validator,
    this.hint,
    this.hintStyle,
    this.controller,
    this.maxLines,
    this.maxLength,
    required this.readOnly,
    this.textAlign,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                // flex: 0,
                child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20),
              child: TextFormField(
                textInputAction: textInputAction,
                textAlign: textAlign ?? TextAlign.left,
                onTap: onTap,
                autovalidateMode: AutovalidateMode.always,
                readOnly: readOnly,
                controller: controller,
                onSaved: onSaved,
                validator: validator,
                cursorColor: Colors.indigo,
                maxLines: maxLines,
                maxLength: maxLength,
                keyboardType: TextInputType.multiline,
                inputFormatters: [],
                decoration: InputDecoration(
                  icon: titleIcon,
                  contentPadding: const EdgeInsets.all(0),
                  hintText: hint,
                  hintStyle: hintStyle,
                  counterText: '',
                  // labelStyle: TextStyle(color: Colors.black38),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            )),
          ],
        )
      ],
    );
  }
}
