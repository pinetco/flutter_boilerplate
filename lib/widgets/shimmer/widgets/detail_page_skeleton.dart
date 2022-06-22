import 'package:flutter/material.dart';

import 'box_decoration.dart';

class DetailPageSkeleton extends StatelessWidget {
  final Animation<double> animation;

  const DetailPageSkeleton({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: width * 0.50,
            width: width,
            decoration: ShimmerBoxDecoration(animation, isCircle: false, radius: 8),
          ),
          Container(
            width: width,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  height: height * 0.020,
                  width: width * 0.7,
                  decoration: ShimmerBoxDecoration(animation),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 5,
                  width: width * 0.8,
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
          ),
          Container(
            width: width,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  height: 5,
                  width: width * 0.7,
                  decoration: ShimmerBoxDecoration(animation),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 5,
                  width: width * 0.8,
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
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                decoration: ShimmerBoxDecoration(animation, isCircle: true),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: width * 0.13,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: width * 0.3,
                      decoration: ShimmerBoxDecoration(animation),
                    ),
                    Container(
                      height: 5,
                      width: width * 0.2,
                      decoration: ShimmerBoxDecoration(animation),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                4,
                (i) => Container(
                  height: 5,
                  width: width * 0.8,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: ShimmerBoxDecoration(animation),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
