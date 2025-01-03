import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/const/colors.dart';
import '../../widgets/functions/custom_login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordReController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordReController.dispose();
    super.dispose();
  }

  Future<bool> registerAccount(String emailValue, String passwordValue) async {
    bool isRegisterSuccess = false;
    final AuthResponse response =
    await supabase.auth.signUp(email: emailValue, password: passwordValue);
    if (response.user != null) {
      isRegisterSuccess = true;
      print(response.user);
      // supabase DB에 등록
      // await supabase
      //     .from('user')
      //     .insert(UserModel(email: emailValue, uid: response.user!.id, name:'').toMap());
      // 사용자 정보 저장
      await supabase.from('user').insert({
        'id': response.user!.id,
        'email': emailValue,
        'nickname': '',
        'profile_url': 'https://24cled-distsance-bucket.s3.ap-northeast-2.amazonaws.com/user-profile/gomzy_theme.jpg',
        'created_at': DateTime.now().toIso8601String(),
      });

    } else {
      isRegisterSuccess = false;
    }

    return isRegisterSuccess;
  }

  void signUp() async {
    String emailValue = _emailController.text;
    String passwordValue = _passwordController.text;
    String rePasswordValue = _passwordReController.text;
    // 유효성 검사
    if (passwordValue != rePasswordValue) {
      _showDialog('회원가입 실패', '비밀번호가 일치하지 않습니다. 다시 확인해 주세요.');
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); //  Form 내부의 TextFormField 들의 onSaved 가 호출됨.

      try {
        bool isRegisterSuccess =
        await registerAccount(emailValue, passwordValue);

        if (!context.mounted) return;
        if (!isRegisterSuccess) {
          _showDialog('회원가입 실패', '회원가입에 실패했습니다. 다시 시도해주세요.');
          return;
        }

        _showDialog('회원가입 성공', '회원가입에 성공했습니다.');

        // Navigator.popAndPushNamed(context, '/main');
        // bottomIndex 지정 필요할 듯
      } catch (e) {
        _showDialog('회원가입 실패', '회원가입에 실패했습니다. 다시 시도해주세요.');
        print(e);
      }
    } else {
      return;
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: _formKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      backgroundColor: DARK_BACKGROUND,
      appBar: CustomBackAppBar(
          appbarTitle: '회원가입',
          isLeading: true,
          isCenterTitle: true,
          backFunction : Navigator.of(context).pop,
          backgroundColor: DARK_BACKGROUND,
          contentColor: WHITE),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextFormField(
                hintText: 'E-mail',
                maxLines: 1,
                fieldWidth: fieldWidth,
                isPasswordField: false,
                isReadOnly: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: _emailController,
                validator: (value) => inputEmailValidator(value),
                // onSaved: (value) =>  _email = value!,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                hintText: '비밀번호',
                maxLines: 1,
                fieldWidth: fieldWidth,
                isPasswordField: true,
                isReadOnly: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                validator: (value) => inputPasswordValidator(value),
                // onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                hintText: '비밀번호 확인',
                maxLines: 1,
                fieldWidth: fieldWidth,
                isPasswordField: true,
                isReadOnly: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                controller: _passwordReController,
                validator: (value) => inputPasswordReValidator(value),
                // onSaved: (value) => _rePassword = value!,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: PRIMARY_LIGHT),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  backgroundColor: DARK_BACKGROUND,
                  foregroundColor: TRANSPARENT,
                  overlayColor: TRANSPARENT,
                  fixedSize: Size(fieldWidth, 48),
                ),
                onPressed: signUp,
                child: const Text('가입하기',
                    style: TextStyle(color: PRIMARY_LIGHT, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
