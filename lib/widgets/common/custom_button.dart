import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/theme/app_css.dart';
import '../../controllers/common/app_controller.dart';
import '../../extensions/spacing.dart';
import '../../extensions/text_style_extensions.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

  final String title;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final Color? color;
  final Widget? icon;
  final double? width;
  final Border? border;
  final bool? iconCenter;

  CustomButton({
    Key? key,
    required this.title,
    this.padding,
    this.radius = 10,
    this.onTap,
    this.style,
    this.color,
    this.icon,
    this.width,
    this.border,
    this.iconCenter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        color: color ?? appCtrl.appTheme.primary,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: padding ?? const EdgeInsets.all(Insets.i15),
              width: width ?? MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: border,
                borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Row(
                      children: [
                        icon ?? const HSpace(0),
                        const HSpace(10),
                      ],
                    ),
                  Expanded(
                    flex: iconCenter == true ? 0 : 1,
                    child: Text(
                      title,
                      style: style ?? AppCss.h2.textColor(Colors.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
