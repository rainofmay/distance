import 'package:flutter/material.dart';

import '../const/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final double fieldWidth;
  final String? defaultText;
  final String? hintText;
  final bool isPasswordField;
  final bool? isEnabled; // 텍스트필드 활성화 여부
  final int? maxLines;
  final  bool isReadOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator validator;
  final TextEditingController? controller;
  final Icon? prefixIcon;
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
        // onSaved: (value) => widget.onSaved,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly ? true : false,
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
