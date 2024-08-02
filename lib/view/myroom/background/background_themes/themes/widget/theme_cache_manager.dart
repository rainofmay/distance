import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io' as io;

class ThemeCacheManager {
  final Map<String, CacheManager> themeCacheManagers = {};

  CacheManager getCacheManagerForTheme(String theme) {
    if (!themeCacheManagers.containsKey(theme)) {
      themeCacheManagers[theme] = CacheManager(
        Config(
          'cache_$theme',
          stalePeriod: Duration(days: 120),
          maxNrOfCacheObjects: 100,
        ),
      );
    }
    return themeCacheManagers[theme]!;
  }

  Future<io.File> getImageFile(String url, String theme) async {
    if (url.startsWith('file://') || url.startsWith('/')) {
      // 로컬 파일 경로인 경우 (갤러리에서 선택한 이미지 포함)
      return io.File(url.replaceFirst('file://', ''));
    }

    return await getCacheManagerForTheme(theme).getSingleFile(url);
  }
}