import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/login/password_reset_screen.dart';
import 'package:mobile/view/login/register_screen.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../../widgets/functions/custom_login.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  MateViewModel viewModel = Get.find<MateViewModel>();

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        '829800135278-tpqa4lprsna700tnnnsh7nbtnprrovqf.apps.googleusercontent.com',
    serverClientId:
        '829800135278-1v4gff7cgerj5ekffvl5r9spvpeg0snv.apps.googleusercontent.com',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
  Future<void> onGoogleLoginPress(BuildContext context) async {
    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await account?.authentication;

      if (googleAuth == null || googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw Exception('로그인 실패');
      }

      // 사용자 정보 가져오기
      String? email = account?.email;
      String? name = account?.displayName;
      String? profileUrl = account?.photoUrl;

      if (email == null) {
        Get.snackbar('오류', '이메일 정보를 가져올 수 없습니다.');
        return;
      }

      bool userExists = await checkUserExists(email);

      if (userExists) {
        await loginUserWithGoogle(email, googleAuth.idToken!, googleAuth.accessToken!);
        Get.snackbar('로그인 성공', '기존 계정으로 로그인되었습니다.');
      } else {
        await registerUserWithGoogle(email, name, profileUrl, googleAuth.idToken!, googleAuth.accessToken!);
        Get.snackbar('회원가입 성공', 'Google 계정으로 회원가입되었습니다.');
      }

      await widget.viewModel.updateMyProfile();
      // Get.offAll(() => HomeScreen());

    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그인 실패'),
      ));
    }
  }

  Future<void> loginUserWithGoogle(String email, String idToken, String accessToken) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw Exception('로그인 실패');
      }

      // JWT 토큰에 커스텀 클레임 추가
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'is_google_user': true},
        ),
      );

    } catch (error) {
      print('Google 로그인 중 오류 발생: $error');
      rethrow;
    }
  }

  Future<void> registerUserWithGoogle(String email, String? name, String? profileUrl, String idToken, String accessToken) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw Exception('회원가입 실패');
      }

      // JWT 토큰에 커스텀 클레임 추가
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'is_google_user': true},
        ),
      );

      // 사용자 정보 저장
      await supabase.from('user').insert({
        'id': response.user!.id,
        'email': email,
        'name': name,
        'profile_url': profileUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

    } catch (error) {
      print('Google 회원가입 중 오류 발생: $error');
      rethrow;
    }
  }


  Future<void> onKakaoLoginPress(BuildContext context) async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오 로그인 성공 ${token.accessToken}');

      final user = await UserApi.instance.me();
      String? email = user.kakaoAccount?.email;
      String? nickname = user.kakaoAccount?.profile?.nickname;
      String? profileUrl = user.kakaoAccount?.profile?.profileImageUrl;
      if (email == null) {
        Get.snackbar('오류', '이메일 정보를 가져올 수 없습니다.');
        return;
      }

      bool userExists = await checkUserExists(email);

      if (userExists) {
        await loginKaKaoUser(email, token.accessToken);
        Get.snackbar('로그인 성공', '기존 계정으로 로그인되었습니다.');
      } else {
        await registerKaKaoUser(email, nickname, profileUrl ,token.accessToken);
        Get.snackbar('회원가입 성공', '카카오 계정으로 회원가입되었습니다.');
      }

      await widget.viewModel.updateMyProfile();
      // Get.offAll(() => HomeScreen());

    } catch (error) {
      print('카카오 로그인 실패 $error');
      Get.snackbar('오류', '로그인 중 문제가 발생했습니다.');
    }
  }

  Future<bool> checkUserExists(String email) async {
    try {
      final response = await supabase
          .from('user')
          .select()
          .eq('email', email)
          .single();
      return response['uid'] != null;
    } catch (error) {
      print('사용자 확인 중 오류 발생: $error');
      return false;
    }
  }

  Future<void> loginKaKaoUser(String email, String accessToken) async {
    try {
      // 고정된 비밀번호 생성 (이메일 기반)
      String fixedPassword = generateFixedPassword(email);

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: fixedPassword,
      );

      if (response.user == null) {
        throw Exception('로그인 실패');
      }

      // JWT 토큰에 커스텀 클레임 추가
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'is_kakao_user': true},
        ),
      );


    } catch (error) {
      print('로그인 중 오류 발생: $error');
      rethrow;
    }
  }

  Future<void> registerKaKaoUser(String email, String? nickname, String? profileUrl, String accessToken) async {
    try {
      // 고정된 비밀번호 생성
      String fixedPassword = generateFixedPassword(email);

      final response = await supabase.auth.signUp(
        email: email,
        password: fixedPassword,
      );

      if (response.user == null) {
        throw Exception('회원가입 실패');
      }

      // JWT 토큰에 커스텀 클레임 추가
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'is_kakao_user': true},
        ),
      );

      // 사용자 정보 저장
      await supabase.from('user').insert({
        'id': response.user!.id,
        'email': email,
        'name': nickname,
        'profile_url': profileUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

    } catch (error) {
      print('회원가입 중 오류 발생: $error');
      rethrow;
    }
  }

// 이메일 기반으로 고정된 비밀번호 생성
  String generateFixedPassword(String email) {
    var bytes = utf8.encode(email + "some_secret_salt_KAKAO_DISTANCE_OATUH_");
    var digest = sha256.convert(bytes);
    return digest.toString();
  }


  void signIn() async {
    String emailValue = _emailController.text;
    String passwordValue = _passwordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    bool isLoginSuccess = await loginWithEmail(emailValue, passwordValue);

    if (!mounted) return;
    if (!isLoginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그인 실패'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그인 성공'),
      ));

      await widget.viewModel.updateMyProfile();
    }
  }

  Future<bool> loginWithEmail(String emailValue, String passwordValue) async {
    bool isLoginSuccess = false;
    final AuthResponse response = await supabase.auth
        .signInWithPassword(email: emailValue, password: passwordValue);
    if (response.user != null) {
      isLoginSuccess = true;
    } else {
      isLoginSuccess = false;
    }
    return isLoginSuccess;
  }

  void signOut() async {
    try {
      await supabase.auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그아웃 성공'),
      ));
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그아웃 실패'),
      ));
    }
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
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: const Text('DISTANCE',
                    style: TextStyle(color: SECONDARY, fontSize: 15)),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: Colors.grey.withOpacity(0)),
                      )))),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: const Text(
                    'Log in and experience Distance. It is yours.',
                    style: TextStyle(fontSize: 13, color: DARK_UNSELECTED),
                    textAlign: TextAlign.start),
              ),
              const SizedBox(height: 100),
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

                            const SizedBox(height: 20),

                            CustomTextFormField(
                              prefixIcon: Icon(Icons.key_rounded),
                              labelText: 'Password',
                              maxLines: 1,
                              fieldWidth: widthOfLog,
                              isPasswordField: true,
                              isReadOnly: false,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              controller: _passwordController,
                              validator: (value) =>
                                  inputPasswordValidator(value),
                            ),

                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: SECONDARY),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                backgroundColor: WHITE,
                                foregroundColor: TRANSPARENT,
                                overlayColor: TRANSPARENT,
                                fixedSize: Size(widthOfLog, heightOfLog),
                              ),
                              onPressed: signIn,
                              child: const Text('로그인',
                                  style: TextStyle(
                                      color: SECONDARY, fontSize: 16)),
                            ),
                            const SizedBox(height: 10.0), // 버튼과 버튼 사이에 간격 추가
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()),
                                      );
                                    },
                                    child: const Text('회원가입',
                                        style: TextStyle(
                                            color: BLACK, fontSize: 12)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(()=> PasswordResetScreen());
                                    },
                                    child: const Text('비밀번호 찾기',
                                        style: TextStyle(
                                            color: BLACK, fontSize: 12)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

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
                    const SizedBox(height: 15),

                    // 로그아웃 버튼 추가
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            overlayColor: TRANSPARENT,
                            foregroundColor: TRANSPARENT,
                            fixedSize: Size(widthOfLog, heightOfLog),
                            backgroundColor: Colors.red),
                        onPressed: signOut,
                        child: const Text('로그아웃',
                            style: TextStyle(color: WHITE, fontSize: 16))),
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
