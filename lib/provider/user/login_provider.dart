import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mobile/widgets/custom_snackbar.dart';

class LoginProvider {
  static final supabase = Supabase.instance.client;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
    '829800135278-tpqa4lprsna700tnnnsh7nbtnprrovqf.apps.googleusercontent.com',
    serverClientId:
    '829800135278-1v4gff7cgerj5ekffvl5r9spvpeg0snv.apps.googleusercontent.com',
  );

  /* 이메일 가입 */
  Future<void> signInWithEmail(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
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

  /* 구글 로그인 */
  Future<void> signInWithGoogle(BuildContext context) async {
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
        CustomSnackbar.show(title: '오류', message: '이메일 정보를 가져올 수 없습니다.');
        return;
      }

      bool userExists = await checkUserExists(email);

      if (userExists) {
        await loginUserWithGoogle(email, googleAuth.idToken!, googleAuth.accessToken!);
        CustomSnackbar.show(title: 'Google 로그인', message: 'Google 계정으로 로그인 되었습니다.');
      } else {
        await registerUserWithGoogle(email, name, profileUrl, googleAuth.idToken!, googleAuth.accessToken!);
        CustomSnackbar.show(title: '회원가입 완료', message: 'Google 계정으로 회원가입 되었습니다.');
      }

    } catch (error) {
      print(error);
      // CustomSnackbar.show(title: '실패', message: '다시 시도해 주세요.');
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
        'nickname': name,
        'profile_url': 'https://24cled-distsance-bucket.s3.ap-northeast-2.amazonaws.com/user-profile/gomzy_theme.jpg',
        'created_at': DateTime.now().toIso8601String(),
      });

    } catch (error) {
      print('Google 회원가입 중 오류 발생: $error');
      rethrow;
    }
  }

  /* 카카오 로그인 */
  Future<void> signInWithKakao() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오 로그인 성공 ${token.accessToken}');

      final user = await UserApi.instance.me();
      String? email = user.kakaoAccount?.email;
      String? nickname = user.kakaoAccount?.profile?.nickname;
      String? profileUrl = user.kakaoAccount?.profile?.profileImageUrl;
      if (email == null) {
        CustomSnackbar.show(title: '오류', message: '이메일 정보를 가져올 수 없습니다.');
        return;
      }

      bool userExists = await checkUserExists(email);

      if (userExists) {
        await loginKaKaoUser(email, token.accessToken);
        CustomSnackbar.show(title: 'Kakao 로그인', message: 'Kakao 계정으로 로그인 되었습니다.');
      } else {
        await registerKaKaoUser(email, nickname, profileUrl ,token.accessToken);
        CustomSnackbar.show(title: '회원가입 완료', message: 'Kakao 계정으로 회원가입 되었습니다.');
      }

    } catch (error) {
      print('카카오 로그인 실패 $error');
      // CustomSnackbar.show(title: '오류', message: '로그인을 다시 시도해 주세요.');
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
        'nickname': nickname,
        'profile_url': 'https://24cled-distsance-bucket.s3.ap-northeast-2.amazonaws.com/user-profile/gomzy_theme.jpg',
        'created_at': DateTime.now().toIso8601String(),
      });

    } catch (error) {
      print('카카오 회원가입 중 오류 발생: $error');
      rethrow;
    }
  }

  // 이메일 기반으로 고정된 비밀번호 생성
  String generateFixedPassword(String email) {
    var bytes = utf8.encode(email + "some_secret_salt_KAKAO_DISTANCE_OAUTH_");
    var digest = sha256.convert(bytes);
    return digest.toString();
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

  // 로그아웃
  Future<void> signOut(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      CustomSnackbar.show(title: '로그아웃', message: '로그아웃 되었습니다.');
    } catch (error) {
      print(error);
      CustomSnackbar.show(title: '오류', message: '로그아웃에 실패했습니다.');
    }
  }
  // 사용자 탈퇴 기능
  // 간소화된 사용자 계정 삭제 기능
  Future<void> deleteAccount(BuildContext context, String currentUserId) async {
    try {
      // 현재 로그인된 사용자 정보 가져오기
      if (currentUserId == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }
      print(currentUserId);
      // user 테이블에서 사용자 데이터 삭제
      await supabase.from('user').delete().eq('id', currentUserId);


      CustomSnackbar.show(title: '계정 삭제', message: '계정이 성공적으로 삭제되었습니다.');
      // 로그인 화면으로 이동
      Navigator.pop(context);
    } catch (error) {
      print('계정 삭제 중 오류 발생: $error');
      CustomSnackbar.show(title: '오류', message: '계정 삭제에 실패했습니다. 다시 시도해주세요.');
    }
  }



}