import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../routes/index.dart';
import '../utilities/general_utils.dart';
import '../utilities/snack_and_dialogs_utils.dart';

checkApiValidationError(data) {
  dynamic error = data['errors'];
  if (error != null) {
    List keys = error.keys.toList();
    if (keys.isNotEmpty) {
      var msg = '';
      for (int i = 0; i < keys.length; i++) {
        String key = keys[i].toString();
        if (i > 0) msg += '\n';
        msg += error[key][0].toString();
      }
      snackBar(msg, duration: 'long');
    } else {
      snackBar(data['message'], duration: 'long');
    }
  } else {
    snackBar(data['message'] ?? '', duration: 'long');
  }
}

apiExceptionMethod(controllerName, e) async {
  hideLoading();
  snackBar(trans('something_went_wrong'));
}

Future<bool> isNetworkConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity(); //Check For Wifi or Mobile data is ON/OFF
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    final result = await InternetAddress.lookup('google.com'); //Check For Internet Connection
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

goToNoInternetScreen() {
  String currentRoute = Get.currentRoute;
  if (currentRoute != routeName.noInternet) {
    Get.toNamed(routeName.noInternet);
  }
  snackBar(trans('no_internet'));
}
