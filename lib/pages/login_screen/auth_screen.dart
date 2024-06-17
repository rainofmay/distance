import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/pages/login_screen/register_screen.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/custom_login.dart';
import '../myroom.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  void signIn() async{
    String emailValue = _emailController.text;
    String passwordValue = _passwordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    bool isLoginSuccess = await loginWithEmail(emailValue, passwordValue);

    if (!context.mounted) return;
    if (!isLoginSuccess) {
      return showDialog (
        context: context,
        builder: (context) {
          return Text('로그인 실패');
        },
      );
    }

    // 수정 필요
    Navigator.popAndPushNamed(context, '/main');
  }

  Future<bool> loginWithEmail(String emailValue, String passwordValue) async {
    bool isLoginSuccess = false;
    final AuthResponse response = await supabase.auth.signInWithPassword(email: emailValue, password: passwordValue);
    if (response.user != null) {
      isLoginSuccess = true;
    } else {
      isLoginSuccess = false;
    }
    return isLoginSuccess;
  }

  @override
  Widget build(BuildContext context) {
    double widthOfLog = MediaQuery.of(context).size.width * 0.8;
    double heightOfLog = 48;

    return Scaffold(
      backgroundColor: WHITE,
      body: SafeArea(
        child: SingleChildScrollView(
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
                child: const Text('Log in and experience Distance. It is yours.',
                    style: TextStyle(fontSize: 13, color: DARK_UNSELECTED),
                    textAlign: TextAlign.start),
              ),
              const BorderLine(lineHeight: 100, lineColor: TRANSPARENT),
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
                            CustomTextFormField(
                              prefixIcon: Icon(CupertinoIcons.mail),
                              labelText: 'E-mail',
                              maxLines: 1,
                              fieldWidth: widthOfLog,
                              isPasswordField: false,
                              isReadOnly: false,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              controller: _emailController,
                              validator: (value) => inputEmailValidator(value),
                            ),

                            const BorderLine(lineHeight: 20, lineColor: TRANSPARENT),

                            CustomTextFormField(
                              prefixIcon: Icon(Icons.key_rounded),
                              labelText: 'Password',
                              maxLines: 1,
                              fieldWidth: widthOfLog,
                              isPasswordField: true,
                              isReadOnly: false,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              controller: _passwordController,
                              validator: (value) => inputPasswordValidator(value),
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
                              onPressed: signIn,
                              child: const Text('로그인', style: TextStyle(color: SECONDARY, fontSize: 16)),
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
                                            builder: (context) => RegisterScreen()),
                                      );
                                    },
                                    child: const Text('회원가입', style: TextStyle(color: BLACK, fontSize: 12)),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('비밀번호 찾기', style: TextStyle(color: BLACK, fontSize: 12)),
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
                            const SizedBox(width: 20),
                            const Text('Kakao로 로그인',
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

                    const SizedBox(height: 15),

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
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 20),
                            const Text('Google로 로그인',
                                style: TextStyle(color: WHITE, fontSize: 16)),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
