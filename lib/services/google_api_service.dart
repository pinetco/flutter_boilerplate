import 'package:flutter/services.dart';

class GoogleApiService {
  Future<void> setGoogleMapApiKey(String mapKey) async {
    const methodChannel = MethodChannel('com.map_api_key.flutter');

    /// Map data for passing to native code
    Map<String, dynamic> requestData = {"mapKey": mapKey};

    methodChannel.invokeMethod('setGoogleMapKey', requestData).then((value) {
      /// You can receive result back from native code
    });
  }
}
