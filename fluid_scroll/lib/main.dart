import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      home: FluidScroll(),
      debugShowCheckedModeBanner: false,
    ));

class FluidScroll extends StatefulWidget {
  @override
  _FluidScrollState createState() => _FluidScrollState();
}

double _deviceWidth, _midWay;
Color _sliderColor = Colors.purple[500];
const double _thumbSize = 40.0, _strokeWidth = 7.0, _horizontalMargin = 20.0;
const int _maxValue = 500;

TextStyle _getTextStyle(Color color) {
  return TextStyle(color: color, fontSize: 13.0, fontWeight: FontWeight.bold);
}

class _FluidScrollState extends State<FluidScroll>
    with TickerProviderStateMixin {
  Animation<double> _anim;
  AnimationController _animCont;

  double _dx = 0.0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    _animCont =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _anim = Tween(begin: 0.0, end: -_thumbSize)
        .animate(CurvedAnimation(curve: Curves.easeOutBack, parent: _animCont));
  }

  @override
  void dispose() {
    _animCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_deviceWidth == null) {
      _deviceWidth = MediaQuery.of(context).size.width;
      _midWay =
          (_deviceWidth - _strokeWidth - _thumbSize) / 2 - _horizontalMargin;
    }

    return Scaffold(
      backgroundColor: Colors.deepOrange[200],
      body: Center(
        child: Container(
          width: _deviceWidth,
          height: _thumbSize + _strokeWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          margin: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: _sliderColor),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "0",
                    style: _getTextStyle(Colors.white),
                  ),
                  Text(
                    _maxValue.toString(),
                    style: _getTextStyle(Colors.white),
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(0.0 + _dx, 0.0),
                child: GestureDetector(
                  onHorizontalDragDown: (drag) {
                    _animCont.forward(from: 0.0);
                  },
                  onHorizontalDragEnd: (drag) {
                    _animCont.reverse();
                  },
                  onHorizontalDragUpdate: (drag) {
                    setState(() {
                      _dx += drag.primaryDelta;
                      _dx = _dx > 0 ? min(_dx, _midWay) : max(_dx, -_midWay);
                    });
                  },
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) {
                      return Transform.translate(
                        offset: Offset(0.0, _anim.value),
                        child: Container(
                          height: _thumbSize,
                          width: _thumbSize,
                          child: CustomPaint(
                            painter: ThumbPainter(_dx),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThumbPainter extends CustomPainter {
  double dx;

  ThumbPainter(this.dx);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = _thumbSize / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _sliderColor
        ..strokeWidth = _strokeWidth
        ..style = PaintingStyle.stroke,
    );

    TextPainter tp = TextPainter(
        text: TextSpan(
            style: _getTextStyle(_sliderColor),
            text:
                ((dx + _midWay) * _maxValue / 2 / _midWay).toStringAsFixed(0)),
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
