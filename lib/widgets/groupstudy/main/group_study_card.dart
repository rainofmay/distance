import 'dart:io';
import 'package:flutter/material.dart';

class GroupStudyCard extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final File? image;
  final imageAsset;

  GroupStudyCard({super.key,
    required this.name,
    required this.onPressed,
    this.image,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              height: 150.0, // Adjust height as needed
            ),
          ],
        ),
      ),
    );
  }
}