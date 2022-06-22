import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/theme/app_css.dart';
import '../../extensions/widget_extension.dart';
import '../../utilities/image_utils.dart';

class ImagePreview extends StatefulWidget {
  final String url;

  const ImagePreview({Key? key, required this.url}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Stack(
        children: [
          SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: kToolbarHeight),
              child: GestureDetector(
                onDoubleTapDown: (details) => tapDownDetails = details,
                onDoubleTap: () {
                  final position = tapDownDetails!.localPosition;

                  const double scale = 3;
                  final x = -position.dx * (scale - 1);
                  final y = -position.dy * (scale - 1);

                  final zoomed = Matrix4.identity()
                    ..translate(x, y)
                    ..scale(scale);

                  final end = controller.value.isIdentity() ? zoomed : Matrix4.identity();

                  animation = Matrix4Tween(
                    begin: controller.value,
                    end: end,
                  ).animate(CurveTween(curve: Curves.easeOut).animate(animationController));

                  animationController.forward(from: 0);
                },
                child: InteractiveViewer(
                  transformationController: controller,
                  child: imageNetwork(
                    url: widget.url,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: Insets.i20,
            top: Insets.i30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r6),
              child: const Icon(
                Icons.close,
                color: Colors.black,
              ).backgroundColor(Colors.white).gestures(onTap: () => Get.back()),
            ),
          ),
        ],
      ),
    );
  }
}
