import 'package:flutter/material.dart';

import '../common/const/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final double fieldWidth;
  final String? defaultText;
  final String? hintText;
  final bool isPasswordField;
  final bool? isEnabled; // 텍스트필드 활성화 여부
  final int? maxLines;
  final bool isReadOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator validator;
  final TextEditingController? controller;
  final Widget? prefix;
  final Icon? prefixIcon;
  final Widget? suffixWidget;
  final Icon? suffixIcon;
  final Widget? counter;
  final String? labelText;


  CustomTextFormField({
    required this.fieldWidth,
    this.defaultText,
    this.hintText,
    required this.isPasswordField,
    this.isEnabled,
    this.maxLines,
    required this.isReadOnly,
    required this.keyboardType,
    required this.textInputAction,
    this.controller,
    required this.validator,
    this.prefix,
    this.prefixIcon,
    this.suffixWidget,
    this.labelText,
    this.counter,
    this.suffixIcon,
    super.key
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.fieldWidth,
      child: TextFormField(
        initialValue: widget.defaultText,
        validator: (value) => widget.validator(value),
        // onSaved: (value) => widget.onSaved,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly ? true : false,
        maxLines: widget.maxLines,
        cursorColor: THIRD,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: THIRD), // 포커스 시 밑줄 색상
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: GREY), // 포커스 시 밑줄 색상
            ),
          isDense: true,
            contentPadding: EdgeInsets.all(10),
          prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
            suffix: widget.suffixWidget,
            suffixIcon: widget.suffixIcon,
            labelText: widget.labelText,
            hintText: widget.hintText,
            counter: widget.counter,
            labelStyle: TextStyle(color: GREY),
        ),
        obscureText: widget.isPasswordField,
      ),
    );
  }
}
