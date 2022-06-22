import 'package:flutter/services.dart';

import '../config.dart';
import '../widgets/common/custom_button.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var appCtrl = Get.isRegistered<AppController>() ? Get.find<AppController>() : Get.put(AppController());

  int _selectedIndex = 0;

  @override
  void initState() {
    appCtrl.checkDeepLink();
    super.initState();
  }

  void setSelectedTab(index) {
    setState(() {
      if (_selectedIndex == 0 && index == 0) {
        //TODO do something
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {
          showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: appCtrl.appTheme.bg1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12), side: BorderSide(color: appCtrl.appTheme.txt.withOpacity(0.1))),
                titlePadding: const EdgeInsets.all(Insets.i16),
                contentPadding: const EdgeInsets.only(left: Insets.i16, right: Insets.i16),
                actionsPadding: const EdgeInsets.all(Insets.i16),
                alignment: Alignment.center,
                elevation: 0,
                title: Text('App Name', style: AppCss.h2),
                content: Text(trans("exit_confirmation"), style: AppCss.body2.textColor(appCtrl.appTheme.grey)),
                actions: <Widget>[
                  CustomButton(
                    title: trans('no'),
                    width: Sizes.s92,
                    style: AppCss.h3,
                    color: appCtrl.appTheme.bg1,
                    border: Border.all(color: appCtrl.appTheme.borderGray),
                    onTap: () => Get.back(),
                    padding: const EdgeInsets.symmetric(vertical: Insets.i8),
                    radius: AppRadius.r6,
                  ),
                  CustomButton(
                    title: trans('yes_exit'),
                    width: Sizes.s120,
                    style: AppCss.h3.textColor(appCtrl.appTheme.white),
                    padding: const EdgeInsets.symmetric(vertical: Insets.i8),
                    radius: AppRadius.r6,
                    onTap: () => SystemNavigator.pop(),
                  ),
                ],
              );
            },
          );
        } else if (_selectedIndex == 3) {
          //avoid gesture on offer screen
          return false;
        } else {
          setState(() {
            _selectedIndex = 0;
          });
        }
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ...List.generate(5, (index) {
              return Container(
                height: Get.height,
                width: Get.width,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text("Tab ${index + 1}", style: TextStyle(color: Colors.white, fontSize: 24)),
              );
            }),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: appCtrl.appTheme.borderGray)),
          ),
          child: BottomNavigationBar(
            unselectedItemColor: appCtrl.appTheme.txt,
            selectedItemColor: appCtrl.appTheme.txt,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: FontSizes.s10,
            unselectedFontSize: FontSizes.s10,
            type: BottomNavigationBarType.fixed,
            backgroundColor: appCtrl.appTheme.bg1,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(svgAssets.icon, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                activeIcon: SvgPicture.asset(svgAssets.iconSolid, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                label: trans('Tab1'),
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(svgAssets.icon, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                activeIcon: SvgPicture.asset(svgAssets.iconSolid, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                label: trans('Tab2'),
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(svgAssets.icon, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                activeIcon: SvgPicture.asset(svgAssets.iconSolid, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                label: trans('Tab3'),
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(svgAssets.icon, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                activeIcon: SvgPicture.asset(svgAssets.iconSolid, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                label: trans('Tab4'),
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(svgAssets.icon, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                activeIcon: SvgPicture.asset(svgAssets.iconSolid, color: appCtrl.appTheme.txt).paddingOnly(bottom: Insets.i3),
                label: trans('Tab5'),
                tooltip: '',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) => setSelectedTab(index),
          ),
        ),
      ),
    );
  }
}
