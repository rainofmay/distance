import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/user/login_provider.dart';
import 'package:mobile/view/login/password_reset_screen.dart';
import 'package:mobile/view/login/register_screen.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/view_model/user/login_view_model.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';
import '../../widgets/functions/custom_login.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginViewModel loginViewModel = Get.put(LoginViewModel(provider: LoginProvider()));
  final MateViewModel mateViewModel = Get.find<MateViewModel>();
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
                    style: TextStyle(color: THIRD, fontSize: 15)),
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
                    'Log in and experience Distance.',
                    style: TextStyle(fontSize: 13, color: DARK_UNSELECTED),
                    textAlign: TextAlign.start),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                    'You can listen to music from your own background.',
                    style: TextStyle(fontSize: 13, color: DARK_UNSELECTED),
                    textAlign: TextAlign.start),
              ),
              const SizedBox(height: 100),
              Center(
                child: Column(
                  children: [
                    Form(
                      key: loginViewModel.formKey,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Obx(() => CustomTextFormField(
                              prefixIcon: Icon(CupertinoIcons.mail),
                              labelText: 'E-mail',
                              maxLines: 1,
                              fieldWidth: widthOfLog,
                              isPasswordField: false,
                              isReadOnly: false,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              controller: loginViewModel.emailController,
                              validator: (value) => inputEmailValidator(value),
                            )),

                            const SizedBox(height: 20),

                            Obx(() => CustomTextFormField(
                              prefixIcon: Icon(Icons.key_rounded),
                              labelText: 'Password',
                              maxLines: 1,
                              fieldWidth: widthOfLog,
                              isPasswordField: true,
                              isReadOnly: false,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              controller: loginViewModel.passwordController,
                              validator: (value) =>
                                  inputPasswordValidator(value),
                            )),

                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: THIRD),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                backgroundColor: WHITE,
                                foregroundColor: TRANSPARENT,
                                overlayColor: TRANSPARENT,
                                fixedSize: Size(widthOfLog, heightOfLog),
                              ),
                              onPressed: () async {
                                await loginViewModel.signIn(context);
                                await mateViewModel.updateMyProfile();

                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              },
                              child: const Text('로그인',
                                  style: TextStyle(
                                      color: THIRD, fontSize: 16)),
                            ),
                            const SizedBox(height: 10.0), // 버튼과 버튼 사이에 간격 추가
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => RegisterScreen(), preventDuplicates: true);
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
                        onPressed: () async {
                          await loginViewModel.signInWithKakao();
                          await mateViewModel.updateMyProfile();

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
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

                    const SizedBox(height: 16),

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
                        onPressed: () async {
                          await loginViewModel.signInWithGoogle(context);
                          await mateViewModel.updateMyProfile();

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
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
