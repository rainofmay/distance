// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import 'adsHelper.dart';
//
// class AdController extends GetxController {
//   Rx<InterstitialAd?> interstitialAd = Rx<InterstitialAd?>(null);
//   Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);
//
//   RxBool isAdLoaded = false.obs;
//
//   @override
//   void onInit() {
//     loadBannerAd();
//     super.onInit();
//   }
//
//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: AdHelper.interstitialTestAdUnitId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               print("FullScreenContent disimissed");
//               interstitialAd.value = null;
//             },
//           );
//           interstitialAd.value = ad;
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load an interstitial ad: ${err.message}');
//         },
//       ),
//     );
//   }
//
//   void loadBannerAd() {
//     BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       request: AdRequest(),
//       size: AdSize.largeBanner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           bannerAd.value = ad as BannerAd;
//           isAdLoaded.value = true;
//         },
//         onAdFailedToLoad: (ad, err) {
//           print('Failed to load a banner ad: ${err.message}');
//           ad.dispose();
//         },
//       ),
//     ).load();
//   }
//
//
//   void showInterstitialAd() {
//     if (interstitialAd.value != null) {
//       interstitialAd.value!.show();
//     }
//   }
// }