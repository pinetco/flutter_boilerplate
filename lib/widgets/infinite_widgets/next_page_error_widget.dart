import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config.dart';

// ignore: must_be_immutable
class NextPageErrorWidget extends StatelessWidget {
  var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

  final PagingController pagingController;
  final String? message;

  NextPageErrorWidget({Key? key, required this.pagingController, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pagingController.retryLastFailedRequest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message ?? trans('next_page_error_msg'),
              textAlign: TextAlign.center,
              style: AppCss.body3.copyWith(color: appCtrl.appTheme.grey),
            ),
            const VSpace(Sizes.s5),
            const Icon(
              Icons.refresh,
              size: Sizes.s15,
            ),
          ],
        ),
      ).padding(
        top: Insets.i15,
        bottom: Insets.i15,
      ),
    );
  }
}
