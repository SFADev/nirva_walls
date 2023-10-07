import 'dart:io';

class AdsManager {
  static const bool _istestMode = true; // TODO : chnange it to flalse on release

  static String get bannerAdUnitIdHome {
    if (_istestMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // TestingAdId
    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-1538382574285381/1108607819'; // TODO : add value of banner ad id
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }
  }

  static String get interstitialAdUnitIdFullImg {
    if (_istestMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // TestingAdId
    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-1538382574285381/4171553723'; // TODO : add value of interstitial ad id
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }
  }

  static String get interstitialAdUnitIdHome {
    if (_istestMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // TestingAdId
    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-1538382574285381/4856281138'; // TODO : add value of interstitial ad id
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }
  }
}
