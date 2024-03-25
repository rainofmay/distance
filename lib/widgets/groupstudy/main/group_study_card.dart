import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupStudyCard extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final File? image;
  final imageAsset;
  final int? availableNumber;
  final int? participantsNumber;

  GroupStudyCard({
    super.key,
    required this.name,
    required this.onPressed,
    this.image,
    this.imageAsset,
    this.availableNumber,
    this.participantsNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(top:10.0, left:20, bottom: 10, right: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left:3, right:3),
              horizontalTitleGap: 0,
              leading: Icon(CupertinoIcons.person_crop_rectangle_fill, size: 13,),
              title: Text(name, style: TextStyle(fontSize: 12,), ),
              trailing: Text('$participantsNumber / $availableNumber', textAlign: TextAlign.right,),
            ),
             ClipRRect(
               borderRadius: BorderRadius.circular(8.0),
               child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  height: 150.0, // Adjust height as needed
                ),
             ),
          ],
        ),
      ),
    );
  }
}
