import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader2 extends StatefulWidget {
  @override
  _Loader2State createState() => _Loader2State();
}

List _circlePos = [1, 2, 3];

class _Loader2State extends State<Loader2> with TickerProviderStateMixin {
  Animation<double> _anim;
  AnimationController _animCont;

  @override
  void initState() {
    super.initState();

    _animCont =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _anim = Tween(begin: 0.0, end: 80.0).animate(_animCont);

    _animCont.repeat();

    _animCont.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _circlePos.forEach((item) {
          item = item - 1;
          if (item == 0) item = 3;
        });
    });
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
          width: 60,
          height: 60,
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
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromLTWH(
                _getLeft(_circlePos[0], size),
                _getTop(_circlePos[0], size),
                _getWidth(_circlePos[0], size),
                _getHeight(_circlePos[0], size)),
            10,
            10),
        _getPaint());
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromLTWH(
                _getLeft(_circlePos[1], size),
                _getTop(_circlePos[1], size),
                _getWidth(_circlePos[1], size),
                _getHeight(_circlePos[1], size)),
            10,
            10),
        _getPaint());
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromLTWH(
                _getLeft(_circlePos[2], size),
                _getTop(_circlePos[2], size),
                _getWidth(_circlePos[2], size),
                _getHeight(_circlePos[2], size)),
            10,
            10),
        _getPaint());
  }

  double _getHeight(int circleType, Size size) {
    var height = size.height / 2;

    if (animValue < 10) {
      if (circleType == 1)
        height = (size.height / 2 + size.height / 2 * animValue / 10);
    } else if (animValue < 20) {
      if (circleType == 1)
        height = (size.height - size.height / 2 * (animValue - 10) / 10);
    } else if (animValue < 40) {
      //nothing
    } else if (animValue < 50) {
      if (circleType == 3)
        height = (size.height / 2 + size.height / 2 * (animValue - 40) / 10);
    } else if (animValue < 60) {
      if (circleType == 3)
        height = (size.height - size.height / 2 * (animValue - 50) / 10);
    } else if (animValue < 80) {
      //nothing
    }
    return height - 10;
  }

  double _getWidth(int circleType, Size size) {
    var width = size.width / 2;
    if (animValue < 20) {
      //nothing
    } else if (animValue < 30) {
      if (circleType == 2)
        width = (size.width / 2 + size.width / 2 * (animValue - 20) / 10);
    } else if (animValue < 40) {
      if (circleType == 2)
        width = (size.width - size.width / 2 * (animValue - 30) / 10);
    } else if (animValue < 60) {
      //nothing
    } else if (animValue < 70) {
      if (circleType == 1)
        width = (size.width / 2 + size.width / 2 * (animValue - 60) / 10);
    } else if (animValue < 80) {
      if (circleType == 1)
        width = (size.width - size.width / 2 * (animValue - 70) / 10);
    }
    return width - 10;
  }

  double _getLeft(int circleType, Size size) {
    switch (circleType) {
      case 1:
        if (animValue > 70)
          return size.width / 2 * (animValue - 70) / 10;
        else
          return 0;
        break;
      case 2:
        if (animValue < 20)
          return size.width / 2;
        else if (animValue > 20 && animValue < 30)
          return size.width / 2 * (30 - animValue) / 10;
        else
          return 0;
        break;
      case 3:
        return size.width / 2;
        break;
    }
  }

  double _getTop(int circleType, Size size) {
    switch (circleType) {
      case 1:
        if (animValue < 10)
          return 0;
        else if (animValue < 20)
          return size.height / 2 * (animValue - 10) / 10;
        else
          return size.height / 2;
        break;
      case 2:
        return 0;
        break;
      case 3:
        if (animValue > 40 && animValue < 50)
          return size.height / 2 * (50 - animValue) / 10;
        else if (animValue > 50)
          return 0;
        else
          return size.height / 2;
        break;
    }
  }

  Paint _getPaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = Colors.lightGreenAccent;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum CircleType { ONE, TWO, THREE }

/**
 * (1) (2)
 *     (3)
 */
