import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddToBag(),
    ));

class AddToBag extends StatefulWidget {
  @override
  _AddToBagState createState() => _AddToBagState();
}

bool _showText = true, _showTick = false;
double _tickDuration = 100.0, _tickMidPoint = _tickDuration / 2;

class _AddToBagState extends State<AddToBag> with TickerProviderStateMixin {
  Animation<double> _compressAnim, _progressAnim, _tickAnim, _scaleAnim;
  AnimationController _compressAnimCont,
      _progressAnimCont,
      _tickAnimCont,
      _scaleAnimCont;

  bool _animating = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    _compressAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _progressAnimCont =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _tickAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 120));

    _compressAnim = Tween(begin: 150.0, end: 0.0).animate(_compressAnimCont);
    _tickAnim = Tween(begin: 0.0, end: _tickDuration).animate(_tickAnimCont);
    _progressAnim = Tween(begin: 0.0, end: 100.0).animate(_progressAnimCont);
    _scaleAnim = Tween(begin: 1.0, end: 0.7).animate(_scaleAnimCont);

    _scaleAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _scaleAnimCont.reverse(from: 1.0);
      else if (status == AnimationStatus.dismissed)
        _compressAnimCont.forward(from: 0.0);
    });

    _compressAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _progressAnimCont.forward();
      else if (status == AnimationStatus.forward) _showText = false;
    });

    _progressAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showTick = true;
        _tickAnimCont.forward();
      }
    });

    _tickAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 1), () {
          _progressAnimCont.reset();
          _compressAnimCont.reset();
          _tickAnimCont.reset();

          _showTick = false;
          _animating = false;
          _showText = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _compressAnimCont.dispose();
    _progressAnimCont.dispose();
    _tickAnimCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedBuilder(
        animation: _compressAnim,
        builder: (_, __) {
          return GestureDetector(
            onTap: () {
              if (!_animating) {
                _animating = true;
                _scaleAnimCont.forward(from: 0.0);
              }
            },
            child: Container(
              color: Colors.transparent,
              height: 50,
              width: _compressAnim.value,
              child: AnimatedBuilder(
                animation: _tickAnim,
                builder: (_, __) {
                  return AnimatedBuilder(
                    animation: _progressAnim,
                    builder: (_, __) {
                      return AnimatedBuilder(
                        animation: _scaleAnim,
                        builder: (_, __) {
                          return Transform.scale(
                            scale: _scaleAnim.value,
                            child: CustomPaint(
                              painter: ButtonPainter(
                                  _progressAnim.value, _tickAnim.value),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      )),
    );
  }
}

class ButtonPainter extends CustomPainter {
  var loadProgress, tickProgress;

  ButtonPainter(this.loadProgress, this.tickProgress);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()
          ..lineTo(size.width, 0)
          ..moveTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..addArc(
              Rect.fromCenter(
                  center: Offset(0, size.height / 2),
                  height: size.height,
                  width: 50),
              90 * pi / 180,
              180 * pi / 180)
          ..addArc(
              Rect.fromCenter(
                  center: Offset(size.width, size.height / 2),
                  height: size.height,
                  width: 50),
              270 * pi / 180,
              180 * pi / 180),
        _getPaint(Colors.black));

    canvas.drawPath(
        Path()
          ..addArc(
              Rect.fromCenter(
                  center: Offset(size.width / 2, size.height / 2),
                  height: size.height,
                  width: 50),
              (270 + loadProgress * 3) * pi / 180,
              loadProgress * 3.6 * pi / 180),
        _getPaint(Colors.lightGreen));

    if (_showText) {
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900),
              text: "ADD TO BAG"),
          textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(size.width / 2 - textPainter.width / 2,
              size.height / 2 - textPainter.height / 2));
    }

    if (_showTick) {
      var tickPath = Path()..moveTo(-10, size.height / 1.8);

      if (tickProgress <= _tickMidPoint)
        tickPath.lineTo(-10 + tickProgress / _tickMidPoint * 6.0,
            size.height / (1.8 - tickProgress / _tickMidPoint * 0.4));
      else
        tickPath.lineTo(-4, size.height / 1.4);

      if (tickProgress >= _tickMidPoint)
        tickPath.lineTo(
            -4 + 14.0 * (tickProgress - _tickMidPoint) / _tickMidPoint,
            size.height /
                (1.4 + 2.3 * (tickProgress - _tickMidPoint) / _tickMidPoint));

      canvas.drawPath(tickPath, _getPaint(Colors.lightGreen));
    }
  }

  Paint _getPaint(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
