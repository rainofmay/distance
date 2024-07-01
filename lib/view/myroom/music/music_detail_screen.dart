import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';

class MusicDetailScreen extends StatefulWidget {
  const MusicDetailScreen({super.key});

  @override
  State<MusicDetailScreen> createState() => _MusicDetailScreenState();
}

class _MusicDetailScreenState extends State<MusicDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(appbarTitle: 'PlayList', isLeading: true, isCenterTitle: true, backgroundColor: WHITE, contentColor: BLACK),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/themes/summer_theme.jpg',
                    fit: BoxFit.cover,
                    width:  MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {},
                                child: Icon((CupertinoIcons.play_circle), color: SECONDARY)),
                            const SizedBox(width: 8),
                            Text('Morning song for you'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Text('3:56'),
                    )
                  ],
                ),
              ),
              BorderLine(lineHeight: 1, lineColor: GREY.withOpacity(0.1))
            ],
          ),
        ),
      ),
    );
  }
}