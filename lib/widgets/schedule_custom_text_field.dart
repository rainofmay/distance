import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  const CustomTextField({super.key, required this.isTime, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: isTime ? 0 : 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                cursorColor: Colors.grey,
                cursorHeight: 20  ,
                maxLines: 1,
                // expands: !isTime,
                keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
                inputFormatters: isTime? [
                  FilteringTextInputFormatter.digitsOnly
                ] : [],
                decoration: InputDecoration(
                  labelText: label,
                  contentPadding:  EdgeInsets.all(0),
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CALENDAR_COLOR)
                  ),
                  // filled: true,
                  // border: InputBorder.none,
                  // fillColor: Colors.grey[300],
                  suffixText: isTime ? '시' : null,
                ),
                      ),
            ))
      ],
    );
  }
}
