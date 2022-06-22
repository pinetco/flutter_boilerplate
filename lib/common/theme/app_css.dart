import 'package:flutter/material.dart';

import '../../extensions/text_style_extensions.dart';

part 'scale.dart';

class AppCss {
  static const TextStyle nunitoSans = TextStyle(
    fontFamily: Fonts.nunitoSans,
    fontWeight: FontWeight.w400,
    fontFamilyFallback: [Fonts.nunitoSans],
  );

  static TextStyle get h1 => nunitoSans.extraBold.size(FontSizes.s18);
  static TextStyle get h2 => nunitoSans.semiBold.size(FontSizes.s16);
  static TextStyle get h3 => nunitoSans.semiBold.size(FontSizes.s14);
  static TextStyle get h4 => nunitoSans.semiBold.size(FontSizes.s12);
  static TextStyle get h5 => nunitoSans.semiBold.size(FontSizes.s10);

  static TextStyle get body1 => nunitoSans.size(FontSizes.s16);
  static TextStyle get body2 => nunitoSans.size(FontSizes.s14);
  static TextStyle get body3 => nunitoSans.size(FontSizes.s12);
  static TextStyle get body4 => nunitoSans.size(FontSizes.s10);
}
