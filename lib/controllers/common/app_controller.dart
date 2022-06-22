import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links/uni_links.dart';

import '../../config.dart';

class AppController extends GetxController {
  AppTheme _appTheme = AppTheme.fromType(ThemeType.light);
  bool _isLoading = false;

  AppTheme get appTheme => _appTheme;
  bool get isLoading => _isLoading;

  bool analyticCookies = true;
  bool marketingCookies = true;
  bool showCookiesSettings = false;

  @override
  void onReady() {
    updateTheme(Get.isDarkMode ? AppTheme.fromType(ThemeType.dark) : AppTheme.fromType(ThemeType.light));
    super.onReady();
  }

  updateTheme(theme) {
    _appTheme = theme;
    update();
    Get.forceAppUpdate();
  }

  void showLoading() {
    _isLoading = true;
    update();
  }

  void hideLoading() {
    _isLoading = false;
    update();
  }

  Future<void> checkDeepLink() async {
    try {
      final initialUri = await getInitialUri();

      if (initialUri != null && initialUri.toString().contains(env['appShareUrl'])) {
        String data = initialUri.toString().replaceAll(env['appShareUrl'], '');
        List<String> keys = data.split('/');

        var route = keys[0];
        var id = keys[1];

        var decodedId = base64Decoded(id);

        if (route == 'p') {
          Get.toNamed('/screenName', arguments: {"id": decodedId});
        } else if (route == 'j') {
          Get.toNamed('/screenName', arguments: {"id": decodedId});
        }
      }
    } on PlatformException {
      printLog("e");
    } on FormatException catch (e) {
      printLog(e);
    }
  }

  void updateCookie(val, type) {
    if (type == 1) {
      analyticCookies = val;
    } else {
      marketingCookies = val;
    }
    update();
  }

  void showCookieSetting() {
    showCookiesSettings = true;
    update();
  }

  void shareApp({String? code}) async {
    showLoading();
    var shortUrl = env['appShareUrl'] + 'i';
    if (!isNullOrBlank(code)) {
      shortUrl += "/$code";
    }
    String message = trans('share_message') + shortUrl;

    hideLoading();
    Share.share(message);
  }
}
