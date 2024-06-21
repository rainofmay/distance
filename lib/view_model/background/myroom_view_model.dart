import 'package:cached_video_player/cached_video_player.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyroomViewModel extends GetxController {
  final RxBool isImage = true.obs;
  final Rxn<CachedVideoPlayerController> videoController = Rxn<CachedVideoPlayerController>();
  final RxString selectedItemUrl = ''.obs;
  final RxBool isSimpleWindowEnabled = false.obs;
  final RxBool isAudioSpectrumEnabled = false.obs;

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
    } else {
      initializeVideo();
    }
  }

  void initializeVideo() {
    final videoUrl = selectedItemUrl.value;
    if (videoUrl.isNotEmpty) {
      videoController.value = CachedVideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          videoController.value?.play();
          videoController.value?.setLooping(true);
        });
    }
  }

  void setSelectedImageUrl(String url) {
    isImage.value = true;
    selectedItemUrl.value = url;
    saveItemUrl(url);
    saveIsImage(true);
  }

  void setSelectedVideoUrl(String url) {
    isImage.value = false;
    selectedItemUrl.value = url;
    saveItemUrl(url);
    saveIsImage(false);
    initializeVideo();
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isImage.value = prefs.getBool('isImage') ?? true;
    selectedItemUrl.value = prefs.getString('selectedItemUrl') ?? '';
    isSimpleWindowEnabled.value = prefs.getBool('isSimpleWindowEnabled') ?? false;
    isAudioSpectrumEnabled.value = prefs.getBool('isAudioSpectrumEnabled') ?? false;
  }

  Future<void> saveItemUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedItemUrl', url);
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
}
