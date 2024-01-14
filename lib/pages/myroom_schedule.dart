import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class Schedule extends StatelessWidget {
  const Schedule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Schedule Setting')),
        body: Builder(
        builder: (BuildContext context) {
      if (context.watch<Store1>().bottomIndex != 0) {

        Future.delayed(Duration.zero, () {
          Navigator.of(context).pop();
        });
      } return Text('To-do');}),
      // bottomNavigationBar: CustomBottomNavagationBar(),
    );
  }
}
