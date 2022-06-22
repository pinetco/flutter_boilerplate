import '../config.dart';
import '../controllers/splash_controller.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  var splashCtrl = Get.put(SplashController());
  var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double animationWidth = ((screenWidth - 200) * 0.5);
    double animationHeight = ((screenHeight - 100) * 0.5);

    return Scaffold(
      backgroundColor: appCtrl.appTheme.primary,
      body: GetBuilder<SplashController>(
        builder: (_) => Stack(
          children: [
            AnimatedPositioned(
              left: splashCtrl.positionAnimation ? animationWidth : -50,
              bottom: splashCtrl.positionAnimation ? animationHeight : 0,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              onEnd: () => splashCtrl.showLabel(),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      svgAssets.logo,
                      semanticsLabel: 'App Name',
                      width: Sizes.s120,
                    ),
                    AnimatedOpacity(
                      opacity: splashCtrl.appTitleOpacity,
                      duration: Durations.slower,
                      onEnd: () => splashCtrl.animateLoading(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: Insets.i10),
                        child: Text(
                          'App Name',
                          maxLines: 2,
                          style: AppCss.h1.copyWith(color: appCtrl.appTheme.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: Insets.i20,
              left: ((screenWidth - 15) * 0.5),
              child: Visibility(
                visible: splashCtrl.showLoading,
                child: const SizedBox(
                  height: Sizes.s15,
                  width: Sizes.s15,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
