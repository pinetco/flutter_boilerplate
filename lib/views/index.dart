import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/common/app_controller.dart';
import '../services/app_update_service.dart';
import '../services/firebase/firebase_notification_service.dart';
import '../views/home.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

  @override
  void initState() {
    FirebaseNotificationService().setup();
    AppUpdateService().init();

    appCtrl.checkDeepLink();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeLayout();
  }
}
