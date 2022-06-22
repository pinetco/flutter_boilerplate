import '../config.dart';

class Page404 extends StatefulWidget {
  const Page404({Key? key}) : super(key: key);

  @override
  State<Page404> createState() => _Page404State();
}

class _Page404State extends State<Page404> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5), () {
      Get.back();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appCtrl.appTheme.primary,
      /*body: Stack(
        children: [
          Positioned(
            left: animationWidth,
            bottom: animationHeight,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Column(
                children: [
                  SvgPicture.asset(
                    svgAssets.rocketWhite,
                    semanticsLabel: 'Care Rockets',
                    width: Sizes.s120,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Insets.i10),
                    child: Text(
                      'CARE ROCKETS',
                      maxLines: 2,
                      style: AppCss.h1.copyWith(color: appCtrl.appTheme.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Insets.i20,
            left: ((screenWidth - 15) * 0.5),
            child: const SizedBox(
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              height: Sizes.s15,
              width: Sizes.s15,
            ),
          ),
        ],
      ),*/
    );
  }
}
