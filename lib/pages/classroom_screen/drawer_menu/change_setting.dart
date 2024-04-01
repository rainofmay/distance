import 'package:flutter/material.dart';

class ChangeSetting extends StatefulWidget {
  const ChangeSetting({super.key});

  @override
  State<ChangeSetting> createState() => _ChangeSettingState();
}

class _ChangeSettingState extends State<ChangeSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text('설정 변경')
    );
  }
}
