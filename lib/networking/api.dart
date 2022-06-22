import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../common/constants/index.dart';
import '../../models/api_data_class.dart';
import '../../routes/index.dart';
import '../../services/remote_config_service.dart';
import '../../utilities/index.dart';

Dio dio = Dio();

bool isApiLoading = false;
RemoteConfigService remoteConfigService = RemoteConfigService();

class Apis {
  //this is compulsory. do not delete

  Apis() {
    //options
    dio.options
      ..baseUrl = env['apiUrl']
      ..validateStatus = (int? status) {
        return status! > 0; //this will always redirect to onResponse method
      }
      ..headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
      };
    //interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        printLog("::: Api Url : ${options.uri}");
        printLog("::: Api header : ${options.headers}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        printLog("::: Api error : $e");
        return handler.next(e);
      },
    ));
  }

  // ignore: missing_return
  Future<APIDataClass> call(String apiName, body, type) async {
    //default data to class
    APIDataClass apiData = APIDataClass(message: 'No Data', isSuccess: false, validation: false, data: null);
    try {
      bool isInternet = await isNetworkConnection();
      if (isInternet) {
        String? authToken = getStorage(Session.authToken.toString());
        String? languageCode = getStorage(Session.languageCode.toString());
        dio.options.headers["Authorization"] = "Bearer $authToken";
        dio.options.headers["X-localization"] = languageCode ?? 'de';
        dynamic response;

        switch (type) {
          case ApiType.get:
            response = await dio.get(apiName, queryParameters: body);
            break;
          case ApiType.post:
            response = await dio.post(apiName, data: body);
            break;
          case ApiType.delete:
            response = await dio.delete(apiName, data: body);
            break;
          case ApiType.put:
            response = await dio.put(apiName, data: body);
            break;
        }

        printLog("::: Api response ($apiName) : $response");
        apiData = await checkStatus(response, apiName);
      } else {
        return APIDataClass(
          isSuccess: false,
          validation: false,
          message: trans('no_internet'),
          data: null,
        );
        //goToNoInternetScreen();
      }
      return apiData;
    } on SocketException catch (e) {
      onSocketException(e);
      return apiData;
    } on Exception catch (e) {
      onException(e);
      return apiData;
    }
  }

  //#region functions
  Future<APIDataClass> checkStatus(response, apiName) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIDataClass(
        isSuccess: true,
        validation: false,
        message: 'Success',
        data: response.data,
      );
    } else if (response.statusCode == 422 || response.statusCode == 404) {
      return APIDataClass(
        isSuccess: false,
        validation: true,
        message: 'validation failed',
        data: response.data,
      );
    } else if (response.statusCode == 401) {
      snackBar(trans('unauthorised_access'));
      removeSpecificKeyStorage(Session.authToken.toString());
      Get.offAllNamed(routeName.login);

      return APIDataClass(
        isSuccess: false,
        validation: true,
        message: 'validation failed',
        data: response.data,
      );
    } else {
      return APIDataClass(
        isSuccess: false,
        validation: true,
        message: response.statusMessage,
        data: response.data ?? {'message': 'Try again after some time'},
      );
    }
  }

  onSocketException(e) {
    //do not delete
    snackBar(trans('no_internet'));
  }

  onException(e) {
    //do not delete
    snackBar(trans('went_wrong'));
  }
}
