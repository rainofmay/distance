import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class BackgroundProvider extends ChangeNotifier {
  int _selectedCategoryIndex = 0;
  int _selectedIndex = 0;
  String _selectedURL = 'assets/images/backgroundtext1.jpeg';
  bool _isImage = true;
  late VideoPlayerController _videoController; // 비디오 컨트롤러 추가

  int get selectedCategoryIndex => _selectedCategoryIndex;
  int get selecteIndex => _selectedIndex;
  bool get isImage => _isImage;
  VideoPlayerController get videoController => _videoController; // Getter 추가

  set isImage(bool isImage) {
    _isImage = isImage;
    if (!isImage) {
      // 비디오를 사용할 경우 비디오를 초기화
      initializeVideo();
    }
    notifyListeners();
    saveIsImage(isImage);
  }
  // 비디오를 초기화하는 메소드
  void initializeVideo() {
    final videoUrl = Uri.parse('https://firebasestorage.googleapis.com/v0/b/cled-180e0.appspot.com/o/video%2Fsea(1080p).mp4?alt=media&token=93b8b695-4f52-4f34-a10c-0c78f135d4d4');
    _videoController = VideoPlayerController.networkUrl(videoUrl)
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        notifyListeners(); // 비디오가 초기화되었음을 알림
      });
  }

  set selectedCategoryIndex(int id) {
    _selectedCategoryIndex = id;
    notifyListeners();
    // 저장
    saveCategoryIndex(id);
  }

  set selectedIndex(int id) {
    _selectedIndex = id;
    notifyListeners();
    // 저장
    saveIndex(id);
  }

  set selectedImageURL(String url) {
    _selectedURL = url;
  }

  List<List<String>> imageURLs = [
    [
      'assets/images/cafe1.jpeg',
      'assets/images/cafe2.jpeg',
      'assets/images/cafe3.jpeg',
    ],
    [
      'assets/images/jazz1.jpeg',
      'assets/images/jazz2.jpeg',
      'assets/images/jazz3.jpeg',
    ],
    [
      'assets/images/nature1.jpeg',
      'assets/images/nature2.jpeg',
      'assets/images/nature3.jpeg',
    ],
  ];


  String get selectedImageURL {
    if (selectedCategoryIndex >= 0 &&
        selectedCategoryIndex < imageURLs.length) {
      int categoryIndex = selectedCategoryIndex;
      int imageIndex = selecteIndex; // 기본값 또는 예외 처리

      if (categoryIndex > 0) {
        // 현재 선택된 카테고리가 0이 아닌 경우, 현재 선택된 이미지 인덱스를 가져옴
        if (imageIndex >= imageURLs[categoryIndex].length) {
          // 예외 처리: 현재 선택된 이미지 인덱스가 범위를 벗어나면 기본값으로 설정
          imageIndex = 0;
        }
      }

      return imageURLs[categoryIndex][imageIndex];
    } else {
      // 기본값 또는 예외 처리를 여기에 추가
      return imageURLs[0][0];
    }
  }

  // 생성자에서 저장된 값 불러오기
  BackgroundProvider() {
    loadCategoryIndex();
    loadIndex();
    loadIsImage();
  }

  // SharedPreferences를 이용한 저장과 불러오기
  Future<void> saveCategoryIndex(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedCategoryIndex', id);
  }
  Future<void> loadCategoryIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedId = prefs.getInt('selectedCategoryIndex');
    if (savedId != null) {
      selectedCategoryIndex = savedId;
      notifyListeners();
      print("saveCategoryId was loaded");
    } else {
      print("saveCategoryId is null");
    }
  }

  Future<void> saveIndex(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', id);
  }
  Future<void> loadIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedId = prefs.getInt('selectedIndex');
    if (savedId != null) {
      selectedIndex = savedId;
      print("saveId was loaded");
      notifyListeners();
    } else {
      print("saveId is null");
    }
  }

  Future<void> saveIsImage(bool isImg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isImage', isImg);
  }
  Future<void> loadIsImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isImg = prefs.getBool('isImage');
    if (isImg != null) {
      isImage = isImg;
      print("isImage was loaded : $isImage");
      notifyListeners();
    } else {
      print("isImage is null");
    }
  }


}