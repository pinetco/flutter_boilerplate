import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/theme/app_css.dart';
import '../../controllers/common/app_controller.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

  final TextEditingController? controller;
  final String? hint;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final double? radius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final int? maxLength;
  final bool showCounter;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool showBoarder;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isDense;
  final bool autofocus;
  final InputBorder? inputBorder;
  final AutovalidateMode? autovalidateMode;

  CustomTextFormField({
    Key? key,
    this.controller,
    this.hint,
    this.hintText,
    this.labelText,
    this.errorText,
    this.radius,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.obscureText = false,
    this.validator,
    this.padding,
    this.fillColor,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType,
    this.enabled = true,
    this.maxLength,
    this.showCounter = false,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.showBoarder = true,
    this.textAlignVertical = TextAlignVertical.center,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.isDense,
    this.autofocus = false,
    this.inputBorder,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius ?? 12),
      borderSide: BorderSide(width: 1, style: showBoarder ? BorderStyle.solid : BorderStyle.none, color: appCtrl.appTheme.borderGray),
    );

    return TextFormField(
      controller: controller,
      style: style ?? AppCss.body1,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      maxLength: maxLength,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      focusNode: focusNode,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        border: inputBorder,
        focusedBorder: inputBorder,
        errorBorder: inputBorder,
        focusedErrorBorder: inputBorder,
        errorStyle: TextStyle(color: Theme.of(context).errorColor),
        filled: true,
        fillColor: fillColor ?? appCtrl.appTheme.bg1,
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        errorMaxLines: 2,
        counterText: showCounter ? null : '',
        isDense: isDense,
        prefixIcon: prefixIcon != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), child: prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: suffixIcon) : null,
      ),
    );
  }
}
