import '../../config.dart';

abstract class UserMixin {
  Future<bool> someFunction() async {
    try {
      showLoading();
      bool val = false;
      await apis.call(apiMethods.login, null, ApiType.get).then((resData) async {
        hideLoading();
        if (resData.isSuccess == true) {
          //ToDO something
        } else if (resData.validation == true) {
          checkApiValidationError(resData.data);
        }
      });
      return val;
    } on Exception catch (e) {
      apiExceptionMethod('UserMixin - unFollow', e);
      return false;
    }
  }
}
