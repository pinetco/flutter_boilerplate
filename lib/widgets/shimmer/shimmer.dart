import 'package:flutter/material.dart';

import 'widgets/detail_page_skeleton.dart';
import 'widgets/feed_skeleton.dart';
import 'widgets/job_skeleton.dart';
import 'widgets/notification_skeleton.dart';
import 'widgets/user_row_skeleton.dart';

enum ShimmerType {
  job,
  detailPage,
  feed,
  notification,
  userRow,
}

class Shimmer extends StatefulWidget {
  final dynamic type;

  const Shimmer({Key? key, required this.type}) : super(key: key);

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return widget.type == ShimmerType.detailPage
            ? DetailPageSkeleton(animation: animation)
            : widget.type == ShimmerType.feed
                ? FeedSkeleton(animation: animation)
                : widget.type == ShimmerType.job
                    ? JobSkeleton(animation: animation)
                    : widget.type == ShimmerType.notification
                        ? NotificationSkeleton(animation: animation)
                        : widget.type == ShimmerType.userRow
                            ? UserRowSkeleton(animation: animation)
                            : Container();
      },
    );
  }
}
