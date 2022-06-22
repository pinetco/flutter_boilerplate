import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../config.dart';

class SplashController extends GetxController {
  bool positionAnimation = false;
  bool showLoading = false;
  double appTitleOpacity = 0;

  @override
  void onInit() {
    ///Remove catch images
    try {
      if ((env['catchClearOnSplash'] ?? true) == true) {
        DefaultCacheManager().emptyCache().then((value) {});
      }
    } on Exception catch (e) {
      printLog(e);
    }
    super.onInit();
  }

  @override
  void onReady() async {
    positionAnimation = true;
    update();
    await Future.delayed(Durations.slowest);

    setLanguage();
    checkLogin();

    super.onReady();
  }

  void animateLoading() {
    showLoading = true;
    update();
  }

  void showLabel() {
    appTitleOpacity = 1;
    update();
  }

  void setLanguage() {
    String? languageCode = getStorage(Session.languageCode);
    String? countryCode = getStorage(Session.countryCode);

    if (languageCode != null && countryCode != null) {
      var locale = Locale(languageCode, countryCode);
      Get.updateLocale(locale);
    } else {
      Get.updateLocale(Get.deviceLocale!);

      writeStorage(Session.languageCode, Get.deviceLocale!.languageCode);
      writeStorage(Session.countryCode, Get.deviceLocale!.countryCode);
    }
  }

  bool isLogin() {
    String? authToken = getStorage(Session.authToken);
    bool? stayLogin = getStorage(Session.stayLogin) ?? false;
    var id = getStorage(Session.id);

    if (authToken != null && id != null && stayLogin == true) {
      return true;
    } else {
      return false;
    }
  }

  void checkLogin() async {
    bool isOnboarded = getStorage(Session.isOnboarded) ?? false;
    if (isLogin()) {
      Get.offAndToNamed(routeName.home);
    } else if (isOnboarded == false) {
      Get.offAndToNamed(routeName.home);
    } else {
      Get.offAndToNamed(routeName.home);
    }
  }
}
