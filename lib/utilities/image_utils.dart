import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show get;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config.dart';
import '../widgets/common/image_preview.dart';

final ImagePicker _picker = ImagePicker();

Future<String?> pickImagePath(ImageSource source) async {
  CroppedFile? file;

  XFile? image = await _picker.pickImage(
    source: source,
    imageQuality: 80,
    maxHeight: 1350,
    maxWidth: 1080,
  );

  if (image != null) {
    file = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
          minimumAspectRatio: 1.0,
        ),
      ],
    );
  }

  return file!.path;
}

Future<List<String>?> pickMultiImagePath() async {
  List<XFile>? images = await _picker.pickMultiImage(
    imageQuality: 80,
    maxHeight: 1350,
    maxWidth: 1080,
  );
  if (images!.isNotEmpty) {
    return [...images.map((e) => e.path)];
  } else {
    return null;
  }
}

Future<File?> singleImagePicker(ImageSource source) async {
  CroppedFile? file;

  XFile? image = await _picker.pickImage(source: source, imageQuality: 80, maxHeight: 1350, maxWidth: 1080).onError((error, stackTrace) async {
    if (error.toString().contains('access_denied')) {
      alertConfirmation(
        title: trans('permission_required'),
        message: trans(source == ImageSource.camera ? 'camera_permission_denied' : 'gallery_permission_denied'),
        context: Get.context,
        onConfirm: () {
          Get.back();
          openAppSettings();
        },
      );
    }
    return null;
  });

  if (image != null) {
    file = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: trans('cropper'),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          toolbarColor: appCtrl.appTheme.primary,
          activeControlsWidgetColor: appCtrl.appTheme.primary,
        ),
        IOSUiSettings(
          title: trans('cropper'),
          doneButtonTitle: trans('done'),
          cancelButtonTitle: trans('cancel'),
        ),
      ],
    );
  }

  return File(file!.path);
}

Future<List<XFile>?> multiImagePicker() async {
  List<XFile>? images = await _picker.pickMultiImage(imageQuality: 80, maxHeight: 1350, maxWidth: 1080).onError((error, stackTrace) async {
    if (error.toString().contains('access_denied')) {
      alertConfirmation(
        title: trans('permission_required'),
        message: trans('gallery_permission_denied'),
        context: Get.context,
        onConfirm: () {
          Get.back();
          openAppSettings();
        },
      );
    }
    return null;
  });

  return images;
}

String getImagePath(dynamic url) {
  if (url != null && url is String && url.isNotEmpty) {
    if (url.contains('http') || url.contains('https')) {
      return Uri.encodeFull(url);
    } else {
      return Uri.encodeFull(env['baseUrl'] + url);
    }
  } else {
    return '';
  }
}

Widget imageNetwork({
  required String url,
  double? height,
  double? width,
  BoxFit? fit,
  Widget? placeholder,
  String? errorImageAsset,
}) {
  try {
    if (url.isNotEmpty) {
      if (url.contains('.svg')) {
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ).paddingAll(Insets.i3);
      } else {
        return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) =>
              placeholder ??
              const Center(
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          errorWidget: (context, url, error) {
            if (errorImageAsset != null && errorImageAsset.contains('.svg')) {
              return SvgPicture.asset(
                errorImageAsset,
                width: width,
                height: height,
                fit: BoxFit.cover,
              );
            } else {
              return Image.asset(
                errorImageAsset ?? imageAssets.placeholder,
                width: width,
                height: height,
                fit: BoxFit.cover,
              );
            }
          },
        );
      }
    } else {
      return Image.asset(
        imageAssets.placeholder,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
  } on Exception {
    return Image.asset(
      errorImageAsset ?? imageAssets.placeholder,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}

Future imagePreView(context, url) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (context) {
      return ImagePreview(url: url);
    },
  );
}

Future<String?> saveImageToLocal(String url) async {
  var response = await get(Uri.parse(url));
  // documentDirectory is the unique device path to the area you'll be saving in
  if (response.statusCode == 200 || response.statusCode == 201) {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    //You'll have to manually create subdirectories
    await Directory(firstPath).create(recursive: true);
    // Name the file, create the file, and save in byte form.
    var filePathAndName = '$firstPath/${DateTime.now().toUtc().toIso8601String()}.png';
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    return file2.path;
  } else {
    return null;
  }
}
