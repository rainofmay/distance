import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/user/login_provider.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/view_model/user/login_view_model.dart';
import 'package:mobile/widgets/circle_divider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginViewModel loginViewModel =
      Get.put(LoginViewModel(provider: LoginProvider()));
  final MateViewModel mateViewModel = Get.find<MateViewModel>();

  Future<bool> _precacheImage(BuildContext context) async {
    try {
      await precacheImage(
          AssetImage("assets/images/login_background.jpg"), context);
      return true;
    } catch (e) {
      print("Error precaching image: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthOfLog = 300;
    double heightOfLog = 48;
    return FutureBuilder<bool>(
        future: _precacheImage(context),
        builder: (context, snapshot) {
          return Scaffold(
            body: Stack(children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), // 0.5는 어둡기의 정도
                  BlendMode.darken,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/login_background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 32, bottom: 8),
                          child: const Text('DISTANCE',
                              style: TextStyle(
                                  color: PRIMARY_LIGHT,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                                width: 90,
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey.withOpacity(0)),
                                )))),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 8, bottom: 10),
                          child: const Text(
                              'Your own music, your own background.',
                              style: TextStyle(
                                  fontSize: 13, color: TRANSPARENT_WHITE),
                              textAlign: TextAlign.start),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: const Text('Log in and experience.',
                              style: TextStyle(
                                  fontSize: 13, color: TRANSPARENT_WHITE),
                              textAlign: TextAlign.start),
                        ),
                        const SizedBox(height: 100),
                        const Center(
                            child: Text('LOGIN',
                                style: TextStyle(
                                    letterSpacing: 22,
                                    color: WHITE,
                                    fontSize: 19))),
                        const SizedBox(height: 24),
                        Center(
                          child: CircleDivider(
                            width: 300,
                            color: PRIMARY_LIGHT,
                            thickness: 1.0,
                            circleRadius: 3.0,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Column(
                            children: [
                              //Google로 로그인
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  overlayColor: TRANSPARENT,
                                  foregroundColor: TRANSPARENT,
                                  fixedSize: Size(widthOfLog, heightOfLog),
                                  backgroundColor: WHITE,
                                ),
                                onPressed: () async {
                                  await loginViewModel
                                      .signInWithGoogle(context);
                                  await mateViewModel.updateMyProfile();

                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    Image.asset(
                                      'assets/images/google.png',
                                      width: 21,
                                      height: 21,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Google로 로그인',
                                          style: TextStyle(
                                              color: BLACK, fontSize: 19),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 36,
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              // 애플 로그인
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    overlayColor: TRANSPARENT,
                                    foregroundColor: TRANSPARENT,
                                    fixedSize: Size(widthOfLog, heightOfLog),
                                    backgroundColor: WHITE),
                                onPressed: () async {
                                  await loginViewModel.signInWithApple(context);
                                  await mateViewModel.updateMyProfile();

                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/apple.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Apple로 로그인',
                                          style: TextStyle(
                                              color: BLACK, fontSize: 19),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 36,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              // KAKAO 로그인
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      overlayColor: TRANSPARENT,
                                      foregroundColor: TRANSPARENT,
                                      fixedSize: Size(widthOfLog, heightOfLog),
                                      backgroundColor: Color(0xffFFE812)),
                                  onPressed: () async {
                                    await loginViewModel.signInWithKakao();
                                    await mateViewModel.updateMyProfile();

                                    if (!context.mounted) return;
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 14),
                                      Image.asset(
                                        'assets/images/kakao.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '카카오로 로그인',
                                            style: TextStyle(
                                                color: BLACK, fontSize: 19),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 36,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
          );
        });
  }
}
