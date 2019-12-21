import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Loader1 extends StatefulWidget {
  @override
  _Loader1State createState() => _Loader1State();
}

class _Loader1State extends State<Loader1> with TickerProviderStateMixin {
  Animation<double> _anim;
  AnimationController _animCont;

  @override
  void initState() {
    super.initState();

    _animCont =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _anim = Tween(begin: 0.0, end: 100.0)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: _animCont));

    _animCont.repeat();
  }

  @override
  void dispose() {
    _animCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 50,
      height: 50,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          return CustomPaint(
            painter: LoaderPainter(_anim.value),
          );
        },
      ),
    ));
  }
}

class LoaderPainter extends CustomPainter {
  double animValue;

  LoaderPainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(_getOffset(OffsetType.ONE_ONE, size),
        _getOffset(OffsetType.ONE_TWO, size), _getPaint());
    canvas.drawLine(_getOffset(OffsetType.TWO_ONE, size),
        _getOffset(OffsetType.TWO_TWO, size), _getPaint());
  }

  Offset _getOffset(OffsetType type, Size size) {
    switch (type) {
      case OffsetType.ONE_ONE:
        return animValue <= 25
            ? Offset(0.0, 0.0)
            : animValue > 25 && animValue <= 50
                ? Offset(0.0, 0.0)
                : animValue > 50 && animValue <= 75
                    ? Offset(size.width * (animValue - 50) / 25,
                        size.height * (animValue - 50) / 25)
                    : Offset(size.width * (100 - animValue) / 25,
                        size.height * (100 - animValue) / 25);
        break;
      case OffsetType.ONE_TWO:
        return animValue <= 25
            ? Offset(size.width * (25 - animValue) / 25,
                size.height * (25 - animValue) / 25)
            : animValue > 25 && animValue <= 50
                ? Offset(size.width * (animValue - 25) / 25,
                    size.height * (animValue - 25) / 25)
                : animValue > 50 && animValue <= 75
                    ? Offset(size.width, size.height)
                    : Offset(size.width, size.height);
        break;
      case OffsetType.TWO_ONE:
        return animValue <= 25
            ? Offset(0.0, size.height)
            : animValue > 25 && animValue <= 50
                ? Offset(size.width * (animValue - 25) / 25,
                    size.height * (50 - animValue) / 25)
                : animValue > 50 && animValue <= 75
                    ? Offset(size.width * (75 - animValue) / 25,
                        size.height * (animValue - 50) / 25)
                    : Offset(0.0, size.height);
        break;
      case OffsetType.TWO_TWO:
        return animValue <= 25
            ? Offset(size.width * animValue / 25,
                size.height * (25 - animValue) / 25)
            : animValue > 25 && animValue <= 50
                ? Offset(size.width, 0.0)
                : animValue > 50 && animValue <= 75
                    ? Offset(size.width, 0.0)
                    : Offset(size.width * (100 - animValue) / 25,
                        size.height * (animValue - 75) / 25);
        break;
    }
  }

  Paint _getPaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = Colors.brown
      ..strokeCap = StrokeCap.round;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum OffsetType { ONE_ONE, ONE_TWO, TWO_ONE, TWO_TWO }

/**
 * Offset types :
 * 1_1      2_2
 *    \    /
 *     \  /
 *      \/
 *      /\
 *     /  \
 *    /    \
 * 2_1      1_2
 */
