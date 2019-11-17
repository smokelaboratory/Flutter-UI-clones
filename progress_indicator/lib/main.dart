import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProgressIndicator(),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

bool _isProgressChanged;
double _endProgress = 60,
    _emptyStartAngle,
    _emptySweepAngle,
    _currentProgress = 0.0;
double _prevDisplacement = 0.0;

class _ProgressIndicatorState extends State<ProgressIndicator>
    with TickerProviderStateMixin {
  Animation _anim;
  AnimationController _animCont;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    _animCont = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _restartAnim();
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f0d67),
      body: Stack(
        children: <Widget>[
          Center(
              child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) {
              _currentProgress = _isProgressChanged
                  ? _currentProgress + _anim.value - _prevDisplacement
                  : _anim.value;

              return SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                    painter: ProgressPaint(_anim.value),
                    child: Center(
                        child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: _currentProgress
                                .roundToDouble()
                                .toInt()
                                .toString(),
                            style: TextStyle(
                              fontFamily: "Digital",
                              fontSize: 80.0,
                              color: Colors.white,
                            )),
                        TextSpan(
                            text: " %",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white24,
                            ))
                      ]),
                    ))),
              );
            },
          )),
          Positioned(
            top: 20,
            right: 15,
            child: IconButton(
              icon: Icon(Icons.restore, color: Colors.white),
              onPressed: () {
                _restartAnim();
              },
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.orange,
            child: Icon(Icons.remove, color: Colors.white),
            onPressed: () {
              if (!_animCont.isAnimating && _currentProgress > 0) {
                _isProgressChanged = true;
                _prevDisplacement = 0.0;

                _anim = Tween(begin: 0.0, end: -10.0).animate(_animCont);
                _animCont.forward(from: 0.0);
              }
            },
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colors.orange,
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              if (!_animCont.isAnimating && _currentProgress < 99) {
                _isProgressChanged = true;
                _prevDisplacement = 0.0;

                _anim = Tween(begin: 0.0, end: 10.0).animate(_animCont);
                _animCont.forward(from: 0.0);
              }
            },
          ),
        ],
      ),
    );
  }

  void _restartAnim() {
    _isProgressChanged = false;

    _anim = Tween(begin: 0.0, end: _endProgress).animate(_animCont);
    _animCont.forward(from: 0.0);
  }
}

class ProgressPaint extends CustomPainter {
  double _anim;

  ProgressPaint(this._anim);

  @override
  void paint(Canvas canvas, Size size) {
    var filledStartAngle = 12.0;

    if (_isProgressChanged) {
      filledStartAngle += 17.0;
      _emptyStartAngle += (_anim - _prevDisplacement);
      _emptySweepAngle -= (_anim - _prevDisplacement);
    } else {
      filledStartAngle += 17.0 * _anim / _endProgress;
      _emptyStartAngle = _endProgress + 12.0 + 17.0 * _anim / _endProgress + 3;
      _emptySweepAngle = _anim * (100 - _endProgress) / _endProgress - 6;
    }

    _prevDisplacement = _anim;

    canvas.drawPath(
        Path()
          ..addArc(
              Rect.fromCenter(
                  center: Offset(size.width / 2, size.height / 2),
                  width: size.width,
                  height: size.height),
              _getAngle(_emptyStartAngle),
              _getAngle(_emptySweepAngle)),
        Paint()
          ..color = Colors.white24
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round);

    canvas.drawPath(
        Path()
          ..addArc(
              Rect.fromCenter(
                  center: Offset(size.width / 2, size.height / 2),
                  width: size.width,
                  height: size.height),
              _getAngle(filledStartAngle),
              _getAngle(_currentProgress)),
        Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..strokeCap = StrokeCap.round);
  }

  double _getAngle(double value) {
    return value * pi / 180 * 3.6;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
