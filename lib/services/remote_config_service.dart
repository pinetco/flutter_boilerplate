import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config.dart';
import '../services/firebase/firebase_config.dart';
import '../utilities/version.dart';

const String liveConfigKey = 'live_config';
const String stagingConfigKey = 'staging_config';
const String updateConfigKey = 'update_config';
const String iosVersionNameKey = 'ios_version_name';
const String androidVersionNameKey = 'android_version_name';

const String androidVersionNameDefault = '1.0.0';
const String iosVersionNameDefault = '1.0.0';

class RemoteConfigService {
  FirebaseRemoteConfig? remoteConfig;

  Future<bool> init() async {
    try {
      await initialize();
      await refresh();
      await setValueToLocal();
      return true;
    } on Exception {
      return true;
    }
  }

  Future<FirebaseRemoteConfig?> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
    remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );

    RemoteConfigValue(null, ValueSource.valueStatic);
    return remoteConfig;
  }

  Future<FirebaseRemoteConfig?> refresh() async {
    await remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );
    await remoteConfig!.fetchAndActivate();
    return remoteConfig;
  }

  Future<bool> setValueToLocal() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    dynamic liveConfig = remoteConfig != null ? remoteConfig!.getString(liveConfigKey) : '';
    dynamic stagingConfig = remoteConfig != null ? remoteConfig!.getString(stagingConfigKey) : '';
    dynamic androidVersionName = remoteConfig != null ? remoteConfig!.getString(androidVersionNameKey) : '';
    dynamic iosVersionName = remoteConfig != null ? remoteConfig!.getString(iosVersionNameKey) : '';

    dynamic liveJsonData;
    dynamic stagingJsonData;

    if (isNullOrBlank(liveConfig)) {
      liveJsonData = environment['serverConfig'];
    } else {
      liveJsonData = jsonDecode(liveConfig);
    }

    if (isNullOrBlank(stagingConfig)) {
      stagingJsonData = environment['serverConfig'];
    } else {
      stagingJsonData = jsonDecode(stagingConfig);
    }

    Version currentVersion = Version.parse(appVersion);
    Version liveVersion = Version.parse(Platform.isAndroid ? androidVersionName : iosVersionName);

    if (currentVersion > liveVersion) {
      await writeStorage(Session.serverConfig, stagingJsonData);
    } else {
      await writeStorage(Session.serverConfig, liveJsonData);
    }

    printLog("::: Remote Config Setup");
    printLog("::: currentVersion : $currentVersion");
    printLog("::: liveVersion : $liveVersion");

    //update config
    dynamic updateConfig = remoteConfig != null ? remoteConfig!.getString(updateConfigKey) : '';
    dynamic updateJsonData;
    if (isNullOrBlank(updateConfig)) {
      updateJsonData = environment['updateConfig'];
    } else {
      updateJsonData = jsonDecode(updateConfig);
    }
    await writeStorage(Session.updateConfig, updateJsonData);

    return true;
  }
}
