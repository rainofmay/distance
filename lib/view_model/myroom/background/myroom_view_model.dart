import 'package:cached_video_player/cached_video_player.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyroomViewModel extends GetxController {
  final RxBool isImage = true.obs;
  final Rxn<CachedVideoPlayerController> videoController = Rxn<CachedVideoPlayerController>();
  final RxString selectedItemUrl = ''.obs;
  final RxString selectedItemThumbnail = ''.obs;
  final RxBool isSimpleWindowEnabled = false.obs;
  final RxBool isAudioSpectrumEnabled = false.obs;
  final RxBool isVideoLoading = true.obs;

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
    selectedItemUrl.value = prefs.getString('selectedItemUrl') ?? './assets/images/nature1.jpeg';
    selectedItemThumbnail.value = prefs.getString('selectedItemThumbnail') ?? './assets/images/nature1.jpeg';
    isSimpleWindowEnabled.value = prefs.getBool('isSimpleWindowEnabled') ?? false;
    isAudioSpectrumEnabled.value = prefs.getBool('isAudioSpectrumEnabled') ?? false;

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
}
