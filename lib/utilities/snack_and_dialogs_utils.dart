import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app_extensions.dart';
import '../common/theme/index.dart';
import '../controllers/common/app_controller.dart';
import '../utilities/general_utils.dart';

var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

snackBar(message, {context, duration, type = 'error'}) {
  Color bgColor = type == 'error' ? (Get.isDarkMode ? const Color(0xFF862222) : appCtrl.appTheme.error) : appCtrl.appTheme.green;

  final snackBar = SnackBar(
    backgroundColor: bgColor,
    elevation: 0,
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(message, style: AppCss.h3.copyWith(color: Colors.white), textAlign: TextAlign.center),
    ),
    duration: Duration(milliseconds: duration == 'short' ? 1000 : (duration == 'long' ? 2000 : 1500)),
    padding: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context ?? Get.context).clearSnackBars();
  ScaffoldMessenger.of(context ?? Get.context).showSnackBar(snackBar);
}

appUpdateDialog(
  String message, {
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  bool forceUpdate = false,
}) {
  return Get.defaultDialog(
    title: trans('App Update'),
    middleText: message,
    titleStyle: AppCss.h2,
    barrierDismissible: !forceUpdate,
    middleTextStyle: AppCss.body2,
    contentPadding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
    titlePadding: const EdgeInsets.only(top: 15),
    onWillPop: forceUpdate == true ? () async => false : null,
    actions: [
      if (!forceUpdate)
        ElevatedButton(
          onPressed: onCancel,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            elevation: MaterialStateProperty.resolveWith<double>(
              // As you said you dont need elevation. I'm returning 0 in both case
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return 0;
                }
                return 0; // Defer to the widget's default.
              },
            ),
          ),
          child: Text(
            trans('cancel'),
            style: AppCss.h2.copyWith(color: Colors.grey),
          ),
        ),
      ElevatedButton(
        onPressed: onConfirm,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.resolveWith<double>(
            // As you said you don't need elevation. I'm returning 0 in both case
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return 0;
              }
              return 0; // Defer to the widget's default.
            },
          ),
        ),
        child: Text(
          trans('update'),
          style: AppCss.h2,
        ),
      ),
    ],
  );
}

alertConfirmation({context, title, message, onConfirm, bool barrierDismissible = true}) {
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Get.isDarkMode ? Colors.white10 : Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: Material(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              side: BorderSide(color: appCtrl.appTheme.txt.withOpacity(0.1)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(Insets.i16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r12),
                color: appCtrl.appTheme.bg1,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) Text("$title", style: AppCss.h2).paddingOnly(bottom: Insets.i16),
                  Text(
                    message ?? trans('are_you_sure_delete'),
                    style: AppCss.body2.textColor(appCtrl.appTheme.grey),
                  ),
                  const VSpace(Sizes.s32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ignore: deprecated_member_use
                      RaisedButton(
                        elevation: 0,
                        onPressed: () => Get.back(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r6),
                          side: BorderSide(color: appCtrl.appTheme.txt.withOpacity(0.1)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Insets.i20, vertical: Insets.i8),
                        color: appCtrl.appTheme.bg1,
                        child: Text(trans('cancel'), style: AppCss.h3),
                      ),
                      const HSpace(Sizes.s16),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        elevation: 0,
                        onPressed: onConfirm,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r6),
                          side: BorderSide(color: appCtrl.appTheme.txt.withOpacity(0.1)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Insets.i20, vertical: Insets.i8),
                        color: appCtrl.appTheme.primary,
                        child: Text(trans('continue'), style: AppCss.h3.textColor(Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Future draggableScrollableBottomSheet({
  required BuildContext context,
  double initialChildSize = 0.5,
  double minChildSize = 0.25,
  double maxChildSize = 1.0,
  required ScrollableWidgetBuilder builder,
}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: initialChildSize > 0.5 ? true : false,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (BuildContext context, ScrollController scrollController) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const VSpace(Insets.i30),
                    SafeArea(
                      bottom: false,
                      child: Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Material(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        child: builder(context, scrollController),
                      ),
                    ),
                  ],
                ),
              );
            });
      });
}
