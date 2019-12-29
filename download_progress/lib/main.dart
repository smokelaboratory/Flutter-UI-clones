import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DownloadProgress(),
    ));

int _noOfRotations = 5;
double _thumbMaxSize = 6.0, _arrowAnimMidWay = _thumbMaxSize / 2;
Color _themeColor = Colors.blueAccent;
CurrentAnimElement _currentAnimElement = CurrentAnimElement.ARROW;
bool _showCircle = false;

class DownloadProgress extends StatefulWidget {
  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress>
    with TickerProviderStateMixin {
  Animation<double> _tickAnim, _rotateAnim, _arrowAnim;
  AnimationController _tickAnimCont, _rotateAnimCont, _arrowAnimCont;
  double _rotateEndValue;
  bool _tapAllowed = true;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    _rotateEndValue = (_noOfRotations * -360.0 - 45.0) * pi / 180;

    _tickAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _rotateAnimCont =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _arrowAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    _tickAnim = Tween(begin: 0.0, end: _thumbMaxSize).animate(CurvedAnimation(
        curve: Curves.elasticOut,
        parent:
            _tickAnimCont)); //need any end value with midpoint, so reused arrow values
    _arrowAnim = Tween(begin: 0.0, end: _thumbMaxSize).animate(_arrowAnimCont);
    _rotateAnim = Tween(begin: 0.0 * pi / 180, end: _rotateEndValue).animate(
        CurvedAnimation(curve: Curves.easeInQuart, parent: _rotateAnimCont));

    _arrowAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentAnimElement = CurrentAnimElement.CIRCLE;
        _rotateAnimCont.forward();
      }
    });

    _arrowAnimCont.addListener(() {
      if (_arrowAnimCont.value > 0.5)
        _showCircle =
            true; //to show arrow and circle simulatenously after midpoint
    });

    _rotateAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentAnimElement = CurrentAnimElement.TICK;
        _tickAnimCont.forward();
      }
    });

    _tickAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 2), () {
          _rotateAnimCont.reset();
          _tickAnimCont.reset();
          _arrowAnimCont.reset();
          _currentAnimElement = CurrentAnimElement.ARROW;
          _showCircle = false;
          _tapAllowed = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _tickAnimCont.dispose();
    _rotateAnimCont.dispose();
    _arrowAnimCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _rotateAnim,
          builder: (_, __) {
            return GestureDetector(
              onTap: () {
                if (_tapAllowed) {
                  _tapAllowed = false;
                  _arrowAnimCont.forward(from: 0.0);
                }
              },
              child: SizedBox(
                height: 100,
                width: 100,
                child: AnimatedBuilder(
                  animation: _arrowAnim,
                  builder: (_, __) {
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: _tickAnim,
                          builder: (_, __) {
                            return CustomPaint(
                                painter: DownloadingStatePainter(
                                    _arrowAnim.value, _tickAnim.value));
                          },
                        ),
                        Transform.rotate(
                          angle: _rotateAnim.value,
                          child: CustomPaint(
                            painter:
                                DownloadingProgressPainter(_arrowAnim.value),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                              opacity: _currentAnimElement ==
                                      CurrentAnimElement.CIRCLE
                                  ? 1.0
                                  : 0.0,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${_rotateAnim.value * 100 ~/ _rotateEndValue}",
                                      style: TextStyle(
                                        fontFamily: "Khula",
                                        fontSize: 30.0,
                                        color: Colors.black38,
                                      )),
                                  TextSpan(
                                      text: "%",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black26,
                                      ))
                                ]),
                              )),
                        )
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DownloadingProgressPainter extends CustomPainter {
  double thumbSize;
  DownloadingProgressPainter(this.thumbSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (_currentAnimElement != CurrentAnimElement.TICK)
      canvas.drawCircle(
          Offset(size.width / 2, 0),
          _showCircle ? thumbSize : 0.0,
          Paint()
            ..color = _themeColor
            ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DownloadingStatePainter extends CustomPainter {
  double arrowAnimValue, tickAnimValue;
  DownloadingStatePainter(this.arrowAnimValue, this.tickAnimValue);

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);

    /**
     * Circular path
     */
    canvas.drawCircle(
        center,
        size.width / 2,
        Paint()
          ..color = Colors.blueGrey[100]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);

    /**
     * Download arrow
     */
    var wingsLength = 15.0;
    if (_currentAnimElement == CurrentAnimElement.ARROW) {
      var bodyLength = center.dy - wingsLength;

      var wingsOffset = min(2 * wingsLength * arrowAnimValue / _thumbMaxSize,
          wingsLength); //multiplied 2 to finish wings animation in mid way
      var bodyOffset = arrowAnimValue >= _arrowAnimMidWay
          ? (_thumbMaxSize - arrowAnimValue) / _arrowAnimMidWay
          : 1; //start offset after animation has reached mid way

      var wingsEndPointY = (center.dy + wingsOffset) * bodyOffset;
      var bodyEndPoint =
          Offset(center.dx, (center.dy + wingsLength) * bodyOffset);

      canvas.drawPath(
          Path()
            ..moveTo(center.dx - wingsLength + wingsOffset, wingsEndPointY)
            ..lineTo(bodyEndPoint.dx, bodyEndPoint.dy)
            ..lineTo(center.dx + wingsLength - wingsOffset, wingsEndPointY)
            ..moveTo(bodyEndPoint.dx, bodyEndPoint.dy)
            ..lineTo(
                center.dx,
                max(
                    (bodyLength -
                        2 * bodyLength * arrowAnimValue / _thumbMaxSize),
                    0)), //multiplied 2 to intersect body with 0.0 height in midway
          _getPaint());
    }

    /**
     * Tick mark
     */
    if (_currentAnimElement == CurrentAnimElement.TICK) {
      var shiftFactor = 3.0; //to shift tick in order to bring it in center
      center = Offset(center.dx - shiftFactor, center.dy - shiftFactor);
      var rightWingExtendFactor = 1.7;
      var leftWingOffset = tickAnimValue < _arrowAnimMidWay
          ? tickAnimValue / _arrowAnimMidWay
          : 1;
      var rightWingOffset = tickAnimValue >= _arrowAnimMidWay
          ? (tickAnimValue - _arrowAnimMidWay) / _arrowAnimMidWay
          : 0;

      var tickPath = Path()
        ..moveTo(center.dx - wingsLength,
            center.dy) //final state : (center.dx - wingsLength, center.dy)
        ..lineTo(
            center.dx - wingsLength * (1 - leftWingOffset),
            center.dy +
                wingsLength *
                    leftWingOffset); //final state : (center.dx, center.dy + wingsLength)

      if (tickAnimValue >= _arrowAnimMidWay)
        tickPath.lineTo(
            center.dx + (wingsLength * rightWingExtendFactor) * rightWingOffset,
            (center.dy -
                ((wingsLength / rightWingExtendFactor) * rightWingOffset) +
                (wingsLength *
                    (1 -
                        rightWingOffset)))); //final state : (center.dx + wingsLength * rightWingExtendFactor, center.dy - wingsLength / rightWingExtendFactor)

      canvas.drawPath(tickPath, _getPaint());
    }
  }

  Paint _getPaint() {
    return Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = _themeColor
      ..strokeWidth = 5.0;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum CurrentAnimElement { TICK, ARROW, CIRCLE }

/**
 *    | (body)
 *    |
 *    |
 * \  |  /  (wings)
 *  \ | /
 *   \|/
 */

/**
 *          /
 *         /  (right wing)
 *     \  /
 *      \/
 * (left 
 * wing)
 */
