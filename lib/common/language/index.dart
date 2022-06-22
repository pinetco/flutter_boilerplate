import 'package:get/get.dart';
import 'en.dart';
import 'de.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'de_DE': de,
      };
}
