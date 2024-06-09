import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/pages/register.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'myroom.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    double widthOfLog = MediaQuery.of(context).size.width * 0.8;
    double heightOfLog = 48;

    return Scaffold(
      backgroundColor: WHITE,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:20, top:20, bottom:10),
              child: const Text('DISTANCE',
                  style: TextStyle(color: BLACK, fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Container(
                width: 90,
                  decoration: BoxDecoration(
                      border: Border(
                bottom: BorderSide(width: 1.0, color: SECONDARY),
              )))
            ),
            Padding(
              padding: const EdgeInsets.only(left:20, top:15, bottom:10),
              child: const Text('Log in and distane from others to yours.',
                  style: TextStyle(fontSize: 13, color: DARK_UNSELECTED),
                  textAlign: TextAlign.start),
            ),
            const BorderLine(lineHeight: 60, lineColor: TRANSPARENT),
            Center(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: widthOfLog,
                            child: TextFormField(
                              validator: (input) {
                                if (input == null || input.isEmpty) {
                                  return '이메일을 입력하세요';
                                }
                                // 이메일 형식이 올바른지 확인
                                if (!RegExp(
                                        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                                    .hasMatch(input)) {
                                  return '올바른 이메일 형식이 아닙니다';
                                }
                                return null;
                              },
                              onSaved: (input) => _email = input!,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail_outline_sharp),
                                  labelText: '이메일',
                                  labelStyle: TextStyle(color: GREY),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: SECONDARY), // 포커스 시 밑줄 색상
                                )),
                            ),
                          ),
                          const BorderLine(lineHeight: 20, lineColor: TRANSPARENT),
                          SizedBox(
                            width: widthOfLog,
                            child: TextFormField(
                              validator: (input) {
                                if (input == null || input.isEmpty) {
                                  return '비밀번호를 입력하세요';
                                }
                                // 비밀번호가 6자 이상인지 확인
                                if (input.length < 6) {
                                  return '비밀번호는 최소 6자 이상이어야 합니다';
                                }
                                return null;
                              },
                              onSaved: (input) => _password = input!,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(CupertinoIcons.padlock),
                                  labelText: '비밀번호',
                                  labelStyle: TextStyle(color: GREY),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: SECONDARY),
                                  )),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            style:  ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: SECONDARY
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                              backgroundColor: WHITE,
                              foregroundColor: TRANSPARENT,
                              overlayColor: TRANSPARENT,
                              fixedSize: Size(widthOfLog, heightOfLog),

                            ),
                            onPressed: () {},
                            child: Text('로그인', style: TextStyle(color: SECONDARY, fontSize: 16)),
                          ),
                          SizedBox(height: 10.0), // 버튼과 버튼 사이에 간격 추가
                          Padding(
                            padding: const EdgeInsets.only(right:20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage()),
                                    );
                                  },
                                  child: Text('회원가입', style: TextStyle(color: BLACK, fontSize: 12)),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text('비밀번호 찾기', style: TextStyle(color: BLACK, fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BorderLine(lineHeight: 35, lineColor: TRANSPARENT),

                  // KAKAO 로그인
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          overlayColor: TRANSPARENT,
                          foregroundColor: TRANSPARENT,
                          fixedSize: Size(widthOfLog, heightOfLog),
                          backgroundColor: Color(0xffFFE812)),
                      onPressed: () => onKakaoLoginPress(context),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/kakao.svg',
                            width: 24,
                            height: 24,
                            // colorFilter:
                            // const ColorFilter.mode(TRANSPARENT, BlendMode.srcIn),
                          ),
                          SizedBox(width: 20),
                          Text('Kakao로 로그인',
                              style: TextStyle(color: BLACK, fontSize: 16)),
                        ],
                      )),
                  // BorderLine(lineHeight: 15, lineColor: TRANSPARENT),

                  // NAVER 로그인
                  // ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(8))),
                  //         overlayColor: TRANSPARENT,
                  //         foregroundColor: TRANSPARENT,
                  //         fixedSize: Size(widthOfLog, heightOfLog),
                  //         backgroundColor: Color(0xff03C75A)),
                  //     onPressed: () => onGoogleLoginPress(context),
                  //     child: Row(
                  //
                  //       children: [
                  //         SvgPicture.asset(
                  //           'assets/icons/naver.svg',
                  //           width: 21,
                  //           height: 21,
                  //           colorFilter:
                  //               const ColorFilter.mode(WHITE, BlendMode.srcIn),
                  //         ),
                  //         SizedBox(width: 20),
                  //         Text('NAVER로 로그인',
                  //             style: TextStyle(color: WHITE, fontSize: 16)),
                  //       ],
                  //     )),

                  BorderLine(lineHeight: 15, lineColor: TRANSPARENT),

                  //Google로 로그인
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          overlayColor: TRANSPARENT,
                          foregroundColor: TRANSPARENT,
                          fixedSize: Size(widthOfLog, heightOfLog),
                          backgroundColor: BLACK),
                      onPressed: () => onGoogleLoginPress(context),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/google.png',
                            width: 21,
                            height: 21,
                          ),
                          SizedBox(width: 20),
                          Text('Google로 로그인',
                              style: TextStyle(color: WHITE, fontSize: 16)),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onGoogleLoginPress(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
      clientId:
          '829800135278-tpqa4lprsna700tnnnsh7nbtnprrovqf.apps.googleusercontent.com',
      serverClientId:
          '829800135278-1v4gff7cgerj5ekffvl5r9spvpeg0snv.apps.googleusercontent.com',
    );

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;

      if (googleAuth == null ||
          googleAuth.idToken == null ||
          googleAuth.accessToken == null) {
        throw Exception('로그인 실패');
      }

      // 슈파베이스로 소셜 로그인 진행
      await Supabase.instance.client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken!);

      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MyRoom()),
      );

      print(account);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그인 실패'),
      ));
    }
  }

  onKakaoLoginPress(BuildContext context) {}
}
