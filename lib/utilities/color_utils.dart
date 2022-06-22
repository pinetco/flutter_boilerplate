import 'dart:math';

import 'package:flutter/material.dart';

Color shiftHsl(Color c, [double amt = 0]) {
  var hslc = HSLColor.fromColor(c);
  return hslc.withLightness((hslc.lightness + amt).clamp(0.0, 1.0)).toColor();
}

Color parseHex(String value) => Color(int.parse(value.substring(1, 7), radix: 16) + 0xFF000000);

Color blend(Color dst, Color src, double opacity) {
  return Color.fromARGB(
    255,
    (dst.red.toDouble() * (1.0 - opacity) + src.red.toDouble() * opacity).toInt(),
    (dst.green.toDouble() * (1.0 - opacity) + src.green.toDouble() * opacity).toInt(),
    (dst.blue.toDouble() * (1.0 - opacity) + src.blue.toDouble() * opacity).toInt(),
  );
}

getRandomColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

Color? getColorFromHexCode(String? color) {
  try {
    color = color?.replaceAll('#', '');
    String valueString = '0xFF${color ?? 'FFFFFF'}';
    int value = int.parse(valueString);
    return Color(value);
  } on Exception {
    return null;
  }

  //ex : helper.getColorFromHexCode('#TGDU78');
}
