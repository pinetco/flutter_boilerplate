import '../../../config.dart';
import 'box_decoration.dart';

class JobSkeleton extends StatelessWidget {
  final Animation<double> animation;
  const JobSkeleton({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: appCtrl.appTheme.bg1,
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //image
          Container(
            height: 200,
            width: width,
            decoration: ShimmerBoxDecoration(animation),
          ),
          //Description
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 10,
                      width: width * 0.5,
                      decoration: ShimmerBoxDecoration(animation),
                    ),
                    const SizedBox(height: 10),
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
                Container(
                  height: 50,
                  width: 50,
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
