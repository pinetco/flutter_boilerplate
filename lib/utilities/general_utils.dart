import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

var loadingCtrl = Get.find<AppController>();

List dialCodes = [
  {
    "alpha2Code": "US",
    "dial_code": "+1",
  },
  {
    "alpha2Code": "IN",
    "dial_code": "+91",
  },
  {
    "alpha2Code": "DE",
    "dial_code": "+49",
  }
];

Future<dynamic> splitDialCodeFromPhone(alpha2Code, String phone) async {
  dynamic data;

  for (var code in dialCodes) {
    if (code['alpha2Code'] == alpha2Code) {
      data = {
        'phone': phone.replaceAll(code['dial_code'], ''),
        'dial_code': code['dial_code'],
      };
      break;
    }
  }
  return data;
}

String trans(String val) {
  if (val.isNotEmpty) {
    return val.tr;
  }
  return val;
}

printLog(val) => log("$val");

jsonGet(json, String path, defaultValue) {
  try {
    List pathSplitter = path.split(".");

    /// <String,dynamic> || String
    dynamic returnValue;

    json.forEach((key, value) {
      var currentPatten = pathSplitter[0];
      int index = 0;

      if (currentPatten.contains('[') && currentPatten.contains(']')) {
        int index1 = currentPatten.indexOf('[');
        int index2 = currentPatten.indexOf(']');

        index = int.parse(currentPatten.substring(index1 + 1, index2));
        currentPatten = currentPatten.substring(0, index1);
      }

      if (key == currentPatten) {
        if (pathSplitter.length == 1) {
          returnValue = value;
          return;
        }

        pathSplitter.remove(pathSplitter[0]);

        if (value == null) {
          returnValue = defaultValue;
          return;
        }
        try {
          try {
            value = value.toJson();
          } catch (error) {
            // handle error
          }

          try {
            if (value is List) {
              value = value[index];
            }
          } catch (error) {
            // handle error
          }

          returnValue = jsonGet(value, pathSplitter.join("."), defaultValue);
        } catch (error) {
          returnValue = defaultValue;
        }
        return;
      }
    });

    return returnValue ?? defaultValue;
  } on Exception {
    // TODO
    return defaultValue;
  }

  //ex : helper.jsonGet(jobDetailCtrl.jobData, "salary_range", null);
  //ex : helper.jsonGet(jobDetailCtrl.jobData, "salary_range.from", '');
  //ex : helper.jsonGet(jobDetailCtrl.jobData, "salary_range.from.amount_gross", 0);
  //ex : helper.jsonGet(jobDetailCtrl.jobData, "salary_range[0].from.amount_gross", 'null');
  //ex : helper.jsonGet(jobDetailCtrl.jobData, "salary_range[0].from[1].amount_gross", null);
}

launchURL(String url) async {
  try {
    await launchUrl(Uri.parse(url));
  } on Exception catch (e) {
    printLog(e);
    Get.snackbar('error', 'Could not launch $url');
  }
}

void showLoading() {
  return loadingCtrl.showLoading();
}

void hideLoading() {
  return loadingCtrl.hideLoading();
}

List arrayFilter(List val) {
  if (val.isNotEmpty) {
    List newArray = [];
    for (int i = 0; i < val.length; i++) {
      if (val[i] != null) {
        newArray.add(val[i]);
      }
    }
    return newArray;
  } else {
    return [];
  }
}

bool isNullOrBlank(dynamic val) {
  if (val is List) {
    if (val.isEmpty) {
      return true;
    } else {
      return false;
    }
  } else {
    if (val == null || val == '' || val.toString().isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

String currency(val) {
  var numFormat = NumberFormat.currency(locale: 'de_DE', symbol: '€'); //germany
  return numFormat.format(val);
}

Future<Map<String, dynamic>>? getParams(Uri uri) async {
  String? magicLink = uri.queryParameters['l'];
  Map<String, dynamic> data;
  if (magicLink != null) {
    data = {'linkType': 'magicLink'};
    Uri baseLink = Uri.parse(magicLink);
    baseLink.queryParameters.forEach((k, v) {
      data['token'] = v;
    });
  } else {
    data = {'linkType': 'screen'};
    var args = {};
    uri.queryParameters.forEach((k, v) {
      if (k == 'screen') {
        data['screen'] = v;
      } else {
        args[k] = v;
      }
    });
    data['args'] = args;
  }

  return data;
}

String timeAgo(String? dateTime) {
  String languageCode = getStorage(Session.languageCode);
  Jiffy.locale(languageCode);

  if (dateTime != null) {
    var dateFormat = DateFormat("dd-MM-yyyy hh:mm aa"); // you can change the format here
    var utcDate = dateFormat.format(DateTime.parse(dateTime)); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, true).toLocal();
    var time = Jiffy(localDate).fromNow();
    return time;
  } else {
    return '';
  }
}

get env => getStorage(Session.serverConfig) ?? environment['serverConfig'];

String getUniqueId() {
  DateTime d = DateTime.now();
  String uuId = "${d.day}${d.month}${d.year}${d.hour}${d.minute}${d.second}${d.microsecond}";

  return uuId;
}

String getRandomString(length) {
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

String base64Encoded(credentials) {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encoded = stringToBase64.encode(credentials);

  return encoded;
}

String base64Decoded(credentials) {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String decoded = stringToBase64.decode(credentials);

  return decoded;
}

//#region Date

//#endregion

//#region To
List toList(val) {
  if (val != null && val is List) {
    return val;
  } else {
    return [];
  }
}

String toString(val) {
  if (val != null) {
    return val.toString();
  } else {
    return '';
  }
}

int toInt(val) {
  if (val != null && val != '') {
    return int.parse(val.toString().split('.')[0]);
  } else {
    return 0;
  }
}

bool toBool(val) {
  if (val != null && val != '') {
    if (val is bool) {
      return val;
    } else {
      return val == 'true' ? true : false;
    }
  } else {
    return false;
  }
}

double toDouble(dynamic val) {
  if (val != null) {
    return double.parse(val.toString());
  } else {
    return 0;
  }
}

DateTime toDate(String? date) {
  try {
    if (date != null) {
      return DateTime.parse(date);
    } else {
      return DateTime.now();
    }
  } on Exception {
    return DateTime.now();
  }
}

toDateString(DateTime date, [String? patten]) {
  return DateFormat(patten ?? 'dd-MM-yyyy').format(date);
}
//#endregion
