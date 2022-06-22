import '../../config.dart';

// ignore: must_be_immutable
class NoDataWidget extends StatelessWidget {
  var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

  final Widget? icon;
  final String? titleText;
  final Widget? titleWidget;
  final String? bodyText;
  final Widget? bodyWidget;
  final bool showIcon;

  NoDataWidget({Key? key, this.icon, this.titleText, this.titleWidget, this.bodyText, this.bodyWidget, this.showIcon = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.i16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) icon ?? Image.asset(Get.isDarkMode ? imageAssets.noDataDark : imageAssets.noData, height: Sizes.s150),
          const VSpace(Sizes.s20),
          titleWidget ??
              Text(
                titleText ?? trans('no_result_found'),
                textAlign: TextAlign.center,
                style: AppCss.h2,
              ),
          const VSpace(Sizes.s5),
          bodyWidget ??
              Text(
                bodyText ?? trans('pull_to_refresh'),
                style: AppCss.body3.copyWith(color: appCtrl.appTheme.grey),
                textAlign: TextAlign.center,
              ),
        ],
      ),
    );
  }
}
