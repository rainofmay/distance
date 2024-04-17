import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchToggle extends StatefulWidget {
  final VoidCallback removeTime;
  const SwitchToggle({super.key, required this.removeTime});

  @override
  State<SwitchToggle> createState() => _SwitchToggleState();
}

class _SwitchToggleState extends State<SwitchToggle> {
  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
        value: _isChecked,
        activeColor: Color(0xffC8D8FA),
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value ?? false;
          });
          _isChecked ? null : widget.removeTime;
        },
      ),
    );
  }
}
