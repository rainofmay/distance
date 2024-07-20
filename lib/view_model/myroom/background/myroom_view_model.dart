import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/model/background_model.dart';
import 'package:mobile/provider/myroom/background/myroom_background_provider.dart';
import 'package:mobile/repository/myroom/background/myroom_background_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyroomViewModel extends GetxController {

  final MyroomBackgroundRepository myroomBackgroundRepository = MyroomBackgroundRepository(backgroundProvider: MyroomBackgroundProvider());

  final RxBool isImage = true.obs;
  final Rxn<CachedVideoPlayerController> videoController =
      Rxn<CachedVideoPlayerController>();
  final RxString selectedItemUrl = ''.obs;
  final RxString selectedItemThumbnail = ''.obs;
  final RxBool isSimpleWindowEnabled = false.obs;
  final RxBool isAudioSpectrumEnabled = false.obs;
  final RxBool isBackdropWordEnabled = false.obs;
  final RxBool isVideoLoading = true.obs;

  final Rx<Color> quoteBackdropColor = Color(0x80000000).obs;
  final RxDouble quoteBackdropOpacity = 0.5.obs;
  final Rx<Color> quoteFontColor = Colors.white.obs;
  final RxString quoteFont = 'GmarketSansTTFMedium'.obs;
  final RxDouble quoteFontSize = 18.0.obs;

  final RxString customQuote = ''.obs;
  final RxString customQuoteAuthor = ''.obs;

  RxBool isThemeLoading = true.obs; // 로딩 상태 변수 추가
  final RxList<ThemePicture> themePictures = <ThemePicture>[].obs;
  final RxList<ThemeVideo> themeVideos = <ThemeVideo>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadPreferences();
    ever(isImage, (_) => toggleMedia());
  }

  @override
  void onClose() {
    videoController.value?.dispose();
    super.onClose();
  }

  void toggleMedia() {
    if (isImage.value) {
      videoController.value?.pause();
      videoController.value?.dispose();
      videoController.value = null;
      isVideoLoading.value = true;
    } else {
      initializeVideo();
    }
  }

  void initializeVideo() {
    final videoUrl = selectedItemUrl.value;
    if (videoUrl.isNotEmpty && videoController.value == null) {
      isVideoLoading.value = true;
      videoController.value = CachedVideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          isVideoLoading.value = false;
          videoController.value?.play();
          videoController.value?.setLooping(true);
        }).catchError((error) {
          isVideoLoading.value = false;
        });
    }
  }

  void setSelectedImageUrl(String url, String thumbnailUrl) {
    videoController.value?.dispose();
    videoController.value = null;
    selectedItemUrl.value = url;
    selectedItemThumbnail.value = thumbnailUrl;
    isImage.value = true;
    isVideoLoading.value = true;
    saveItemUrl(url);
    saveThumbnailUrl(thumbnailUrl);
    saveIsImage(true);
  }

  void setSelectedVideoUrl(String videoUrl, String thumbnailUrl) {
    videoController.value?.dispose();
    videoController.value = null;
    selectedItemUrl.value = videoUrl;
    selectedItemThumbnail.value = thumbnailUrl;
    isImage.value = false;
    isVideoLoading.value = true;
    saveItemUrl(videoUrl);
    saveThumbnailUrl(thumbnailUrl);
    saveIsImage(false);
    initializeVideo();
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isImage.value = prefs.getBool('isImage') ?? true;
    selectedItemUrl.value =
        prefs.getString('selectedItemUrl') ?? './assets/images/nature1.jpeg';
    selectedItemThumbnail.value = prefs.getString('selectedItemThumbnail') ??
        './assets/images/nature1.jpeg';
    isSimpleWindowEnabled.value =
        prefs.getBool('isSimpleWindowEnabled') ?? false;
    isAudioSpectrumEnabled.value =
        prefs.getBool('isAudioSpectrumEnabled') ?? false;
    isBackdropWordEnabled.value =
        prefs.getBool('isBackdropWordEnabled') ?? false;

    quoteBackdropColor.value = Color(prefs.getInt('quoteBackdropColor') ?? 0xFFFFFFFF);
    quoteBackdropOpacity.value = prefs.getDouble('quoteBackdropOpacity') ?? 0.5;
    quoteFont.value = prefs.getString('quoteFont') ?? 'GmarketSansTTFMedium';
    quoteFontSize.value = prefs.getDouble('quoteFontSize') ?? 18.0;
    quoteFontColor.value = Color(prefs.getInt('quoteFontColor') ?? 0xFF000000);
    customQuote.value = prefs.getString('customQuote') ?? '';
    customQuoteAuthor.value = prefs.getString('customQuoteAuthor') ?? '';

    if (!isImage.value) {
      initializeVideo();
    }
  }

  Future<void> saveItemUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedItemUrl', url);
  }

  Future<void> saveThumbnailUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedItemThumbnail', url);
  }

  Future<void> saveIsImage(bool isImg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isImage', isImg);
  }

  void updateSimpleWindowChange(value) async {
    isSimpleWindowEnabled.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSimpleWindowEnabled', isSimpleWindowEnabled.value);
  }

  void updateAudioSpectrumChange(value) async {
    isAudioSpectrumEnabled.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAudioSpectrumEnabled', isAudioSpectrumEnabled.value);
  }

  void updateBackdropWordChange(value) async {
    isBackdropWordEnabled.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBackdropWordEnabled', isBackdropWordEnabled.value);
  }

  void updateQuoteBackdropColor(Color color) async {
    quoteBackdropColor.value = color;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('quoteBackdropColor', color.value);
  }

  void updateQuoteBackdropOpacity(double opacity) async {
    quoteBackdropOpacity.value = opacity;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('quoteBackdropOpacity', opacity);
  }

  void updateQuoteFont(String font) async {
    quoteFont.value = font;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('quoteFont', font);
  }

  void updateQuoteFontSize(double size) async {
    quoteFontSize.value = size;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('quoteFontSize', size);
  }
  void updateQuoteFontColor(Color color) async{
    quoteFontColor.value = color;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('quoteFontColor', color.value);
  }

  void updateCustomQuote(String quote) async {
    customQuote.value = quote;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('customQuote', quote);
  }

  void updateCustomQuoteAuthor(String author) async {
    customQuoteAuthor.value = author;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('customQuoteAuthor', author);
  }

  Future<void> setTheme(String category) async {
    isThemeLoading.value = true; // 로딩 시작
    themePictures.value = await myroomBackgroundRepository.fetchThemePictures(category);
    themeVideos.value = await myroomBackgroundRepository.fetchThemeVideos(category);
    isThemeLoading.value = true; // 로딩 시작
  }

}
