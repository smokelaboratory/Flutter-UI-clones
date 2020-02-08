import 'package:flutter/material.dart';
import 'dart:math';

class Loader3 extends StatefulWidget {
  @override
  _Loader3State createState() => _Loader3State();
}

double _movementSweep = 165.0;

class _Loader3State extends State<Loader3> with TickerProviderStateMixin {
  Animation<double> _anim;
  AnimationController _animCont;

  @override
  void initState() {
    super.initState();

    _animCont =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _anim = Tween(begin: 0.0, end: _movementSweep * 3).animate(_animCont);

    _animCont.repeat(reverse: true);
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
  double _radianFactor = pi / 180, _pieceWidth = 20;
  Paint arcPaint = Paint()
    ..color = Colors.lightGreenAccent
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  LoaderPainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
        center: Offset(
          size.width / 2,
          size.height / 2,
        ),
        radius: 20);

    canvas.drawArc(rect, 0, _getAngle(160), false, arcPaint);

    canvas.drawArc(
        rect,
        _getAngle(155.0 + max(animValue - (2 * _movementSweep), 0)),
        _getAngle(_pieceWidth),
        false,
        arcPaint);
    canvas.drawArc(
        rect,
        _getAngle(
            165.0 + min(_movementSweep, max(animValue - _movementSweep, 0))),
        _getAngle(_pieceWidth),
        false,
        arcPaint);
    canvas.drawArc(rect, _getAngle(175.0 + min(animValue, _movementSweep)),
        _getAngle(_pieceWidth), false, arcPaint);
  }

  double _getAngle(double degree) {
    return _radianFactor * degree;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
