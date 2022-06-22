import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:package_info_plus/package_info_plus.dart';

import '../../config.dart';
import '../utilities/version.dart';

class AppUpdateService {
  init() {
    updateAlert();
  }

  updateAlert() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    dynamic data = await getStorage(Session.updateConfig) ?? environment['updateConfig'];
    String androidVersionName = data['android_version_code'];
    String androidMinimumVersionName = data['android_minimum_version_code'];
    String iosVersionName = data['ios_version_code'];
    String iosMinimumVersionName = data['ios_minimum_version_code'];
    bool forceUpdate = data['force_update'];
    String description = data['description'];

    Version currentVersion = Version.parse(appVersion);
    Version liveVersion = Version.parse(Platform.isAndroid ? androidVersionName : iosVersionName);
    Version minimumVersion = Version.parse(Platform.isAndroid ? androidMinimumVersionName : iosMinimumVersionName);

    if (minimumVersion > currentVersion) {
      appUpdateDialog(description, forceUpdate: true, onCancel: cancelAppUpdateDialog, onConfirm: confirmAppUpdate);
    } else if (liveVersion > currentVersion) {
      appUpdateDialog(description, forceUpdate: forceUpdate, onCancel: cancelAppUpdateDialog, onConfirm: confirmAppUpdate);
    }
  }

  cancelAppUpdateDialog() {
    Get.back();
  }

  confirmAppUpdate() async {
    var playStoreUrl = environment['playStoreUrl'];
    var appStoreUrl = environment['appStoreUrl'];
    if (Platform.isAndroid) {
      await launchURL(playStoreUrl);
    } else {
      await launchURL(appStoreUrl);
    }
  }
}
