import 'package:get_storage/get_storage.dart';

import 'common/language/index.dart';
import 'config.dart';
import 'services/firebase/firebase_notification_service.dart';
import 'services/remote_config_service.dart';
import 'views/page_404.dart';
import 'views/splash_screen.dart';

RemoteConfigService remoteConfigService = RemoteConfigService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Init
  await FirebaseNotificationService.init();
  await GetStorage.init();

  //Remote config
  await RemoteConfigService().init();
  //await GoogleApiService().setGoogleMapApiKey(env['googleApiKey']);

  //Global controller
  Get.put(AppController());

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 100),
      debugShowCheckedModeBanner: false,
      translations: Language(),
      locale: const Locale('en', 'EN'),
      fallbackLocale: const Locale('de', 'EN'),
      title: "Care Rockets",
      home: SplashScreen(),
      getPages: appRoute.getPages,
      unknownRoute: GetPage(name: '/page404', page: () => const Page404()),
      theme: AppTheme.fromType(ThemeType.light).themeData,
      darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
      themeMode: ThemeService().theme,
    );
  }
}
