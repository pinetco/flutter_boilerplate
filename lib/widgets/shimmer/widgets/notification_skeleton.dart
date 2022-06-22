import 'package:flutter/material.dart';

import 'box_decoration.dart';

class NotificationSkeleton extends StatelessWidget {
  final Animation<double> animation;
  const NotificationSkeleton({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: ShimmerBoxDecoration(animation, isCircle: true),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 5,
                          width: width * 0.5,
                          decoration: ShimmerBoxDecoration(animation),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 5,
                          width: width * 0.5,
                          decoration: ShimmerBoxDecoration(animation),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Container(
                  height: 30,
                  width: 30,
                  decoration: ShimmerBoxDecoration(animation, isCircle: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
