import '../../../config.dart';
import 'box_decoration.dart';

class FeedSkeleton extends StatelessWidget {
  final Animation<double> animation;
  const FeedSkeleton({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: appCtrl.appTheme.bg1,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: ShimmerBoxDecoration(animation, isCircle: true),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 10,
                  width: width * 0.5,
                  decoration: ShimmerBoxDecoration(animation),
                ),
              ],
            ),
          ),
          //image
          Container(
            height: 200,
            width: width,
            decoration: ShimmerBoxDecoration(animation),
          ),
          //Description
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: width,
                  decoration: ShimmerBoxDecoration(animation),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 5,
                  width: width,
                  decoration: ShimmerBoxDecoration(animation),
                ),
              ],
            ),
          ),
          //comment area
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: ShimmerBoxDecoration(animation, isCircle: true),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 10,
                  width: width * 0.5,
                  decoration: ShimmerBoxDecoration(animation),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
