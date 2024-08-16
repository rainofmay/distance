
import 'package:mobile/model/background_model.dart';
import 'package:mobile/provider/myroom/background/myroom_background_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyroomBackgroundRepository {
  late final MyroomBackgroundProvider _backgroundProvider;
  static final supabase = Supabase.instance.client;

  MyroomBackgroundRepository({
    required MyroomBackgroundProvider backgroundProvider,
  }) : _backgroundProvider = backgroundProvider;

  onInit() {

  }
  //첫 접속자를 위한 사진 불러오기
  Future<List<ThemePicture>> fetchFirstPicture() async {
    final response = await _backgroundProvider.getFirstPicture();

    // 사용자 정보를 ThemePicture 객체로 변환
    final firstPicture = ThemePicture.fromJsonList(response);

    return firstPicture;
  }


  //테마 사진들 불러오기
  Future<List<ThemePicture>> fetchThemePictures(String category) async {
    final response = await _backgroundProvider.getThemePictures(category);

    // 사용자 정보를 ThemePicture 객체로 변환
    final themePictures = ThemePicture.fromJsonList(response);

    return themePictures;
  }

  //테마 영상들 불러오기
  Future<List<ThemeVideo>> fetchThemeVideos(String category) async {
    final response = await _backgroundProvider.getThemeVideos(category);

    // 사용자 정보를 UserModel 객체로 변환
    final themeVideos = ThemeVideo.fromJsonList(response);

    return themeVideos;
  }

  Future<void> setBackgroundImage(String imageUrl) async {
    try {
      await _backgroundProvider.setBackgroundImage(imageUrl);
    } catch (e) {
      // 여기서 오류를 다시 던지거나 로깅할 수 있습니다.
      print('Repository error: $e');
      throw Exception('Failed to set background image: $e');
    }
  }


  Future<void> setBackgroundVideo(String videoUrl) async{
    await _backgroundProvider.setBackgroundVideo(videoUrl);
  }
}