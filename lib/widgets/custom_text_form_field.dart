import 'package:flutter/material.dart';

import '../const/colors.dart';

class CustomTextFormField extends StatefulWidget {
  double fieldWidth;
  String? defaultText;
  String? hintText;
  bool isPasswordField = false;
  bool? isEnabled; // 텍스트필드 활성화 여부
  int? maxLines;
  bool isReadOnly;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FormFieldValidator validator;
  TextEditingController controller;
  Function()? onTap;
  Icon? prefixIcon;
  String? labelText;


  CustomTextFormField({
    required this.fieldWidth,
    this.defaultText,
    this.hintText,
    required this.isPasswordField,
    this.isEnabled, this.maxLines,
    required this.isReadOnly,
    required this.keyboardType,
    required this.textInputAction,
    required this.controller,
    required this.validator,
    this.onTap,
    this.prefixIcon,
    this.labelText,
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
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly ? true : false,
        onTap: widget.isReadOnly ? widget.onTap : null,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(color: GREY),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SECONDARY),
            )
        ),
        obscureText: widget.isPasswordField,
      ),
    );
  }
}
