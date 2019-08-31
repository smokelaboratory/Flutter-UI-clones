import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RatingUi(),
    );
  }
}

class RatingUi extends StatefulWidget {
  @override
  _RatingUiState createState() => _RatingUiState();
}

FaceState _currentFaceState = FaceState.NORMAL, _preFaceState = FaceState.ANGRY;

class _RatingUiState extends State<RatingUi> with TickerProviderStateMixin {
  List<String> _ratingStates = ["Hideous", "Ok", "Good"];

  Animation<double> _faceCurrentAnim,
      _smileAnim,
      _angryAnim,
      _rotateAnim,
      _shakeAnim,
      _opacityAnim,
      _slideAnim;
  Animation<Color> _colorCurrentAnim, _angryColorAnim, _smileColorAnim;

  AnimationController _faceAnimController,
      _rotateAnimController,
      _shakeAnimController,
      _opacityAnimController,
      _slideAnimController;

  String _currentRatingState;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    var normalColor = Color(0xfffdecbc);

    _faceAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _rotateAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _shakeAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _opacityAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _slideAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _rotateAnim =
        Tween(begin: 0.0, end: pi / 180 * 20.0).animate(_rotateAnimController);
    _opacityAnim = Tween(begin: 1.0, end: 0.0).animate(_opacityAnimController);
    _shakeAnim = Tween(begin: 100.0, end: 200.0).animate(_shakeAnimController);
    _slideAnim = Tween(begin: 0.0, end: -50.0).animate(_slideAnimController);
    _smileAnim = Tween(begin: 0.0, end: 20.0).animate(_faceAnimController);
    _smileColorAnim = Tween<Color>(begin: normalColor, end: Color(0xffbcfbe4))
        .animate(_faceAnimController);
    _angryAnim = Tween(begin: 0.0, end: 50.0).animate(_faceAnimController);
    _angryColorAnim = Tween<Color>(begin: normalColor, end: Color(0xfffcbde9))
        .animate(_faceAnimController);

    _currentRatingState = _ratingStates[1];
    _faceCurrentAnim = _smileAnim;
    _colorCurrentAnim = _smileColorAnim;

    _faceAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          _currentFaceState == FaceState.ANGRY)
        _rotateAnimController.forward(from: _rotateAnimController.value);
    });

    _rotateAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _shakeAnimController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _faceAnimController.dispose();
    _shakeAnimController.dispose();
    _slideAnimController.dispose();
    _rotateAnimController.dispose();
    _opacityAnimController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorCurrentAnim,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: _colorCurrentAnim.value,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Stack(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Icon(Icons.close)),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Ride finished",
                      style: TextStyle(
                          fontFamily: "Cabin",
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "How was\nyour ride?",
                      style: TextStyle(
                          height: 0.8,
                          fontFamily: "Cabin",
                          fontSize: 40,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedBuilder(
                      animation: _opacityAnim,
                      builder: (_, __) {
                        return Opacity(
                          opacity: _opacityAnim.value,
                          child: AnimatedBuilder(
                            animation: _slideAnim,
                            builder: (_, __) {
                              return Transform.translate(
                                offset: Offset(_slideAnim.value, 0.0),
                                child: Text(
                                  _currentRatingState,
                                  style: TextStyle(
                                      fontFamily: "Cabin",
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (_, __) {
                        return Transform(
                          transform: Matrix4.translation(vector.Vector3(
                              sin(_shakeAnim.value * pi) * 4, 0.0, 0.0)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AnimatedBuilder(
                                animation: _rotateAnim,
                                builder: (_, __) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Transform.rotate(
                                        angle: _rotateAnim.value,
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          child: AnimatedBuilder(
                                            animation: _faceCurrentAnim,
                                            builder: (_, __) {
                                              return CustomPaint(
                                                painter: EyePainter(
                                                    _faceCurrentAnim.value),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Transform.rotate(
                                        angle: -_rotateAnim.value,
                                        child: Transform(
                                          alignment: FractionalOffset.center,
                                          transform: Matrix4.identity()
                                            ..rotateY(pi),
                                          child: Container(
                                            width: 75,
                                            height: 75,
                                            child: AnimatedBuilder(
                                              animation: _faceCurrentAnim,
                                              builder: (_, __) {
                                                return CustomPaint(
                                                  painter: EyePainter(
                                                      _faceCurrentAnim.value),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Container(
                                width: 150,
                                height: 150,
                                child: AnimatedBuilder(
                                  animation: _faceCurrentAnim,
                                  builder: (_, __) {
                                    return CustomPaint(
                                      painter:
                                          LipsPainter(_faceCurrentAnim.value),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 3 / 4,
                      child: SliderTheme(
                        data: SliderThemeData(
                            thumbShape: CustomSliderThumb(),
                            overlayColor: Colors.transparent,
                            activeTrackColor: Colors.black12,
                            inactiveTrackColor: Colors.black12,
                            trackHeight: 1),
                        child: Slider(
                          min: 0,
                          max: 2,
                          value: _getSliderState(faceState: _currentFaceState),
                          onChanged: (sliderState) {
                            setState(() {
                              if (sliderState !=
                                  _getSliderState(
                                      faceState: _currentFaceState)) {
                                _preFaceState = _currentFaceState;
                                _currentFaceState =
                                    _getFaceState(sliderState: sliderState);

                                if (sliderState <
                                    _getSliderState(faceState: _preFaceState))
                                  _slideAnim = Tween(begin: 0.0, end: -50.0)
                                      .animate(_slideAnimController);
                                else
                                  _slideAnim = Tween(begin: 0.0, end: 50.0)
                                      .animate(_slideAnimController);

                                _slideAnimController
                                    .addStatusListener(_slideAnimListener);
                                _slideAnimController.forward(from: 0.0);
                                _opacityAnimController.forward(from: 0.0);

                                if (_currentFaceState == FaceState.NORMAL) {
                                  _faceAnimController.reverse(from: 1.0);

                                  if (_preFaceState == FaceState.ANGRY)
                                    _rotateAnimController.reverse(
                                        from: _rotateAnimController.value);
                                } else {
                                  _faceAnimController.reset();
                                  if (_currentFaceState == FaceState.ANGRY) {
                                    _faceCurrentAnim = _angryAnim;
                                    _colorCurrentAnim = _angryColorAnim;
                                  } else {
                                    _faceCurrentAnim = _smileAnim;
                                    _colorCurrentAnim = _smileColorAnim;
                                  }
                                  _faceAnimController.forward(
                                      from: _faceAnimController.value);
                                }
                              }
                            });
                          },
                          divisions: 2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _getSliderState({FaceState faceState}) {
    switch (faceState) {
      case FaceState.ANGRY:
        return 0;
        break;
      case FaceState.NORMAL:
        return 1;
        break;
      default:
        return 2;
        break;
    }
  }

  FaceState _getFaceState({double sliderState}) {
    switch (sliderState.toString()) {
      case "0.0":
        return FaceState.ANGRY;
        break;
      case "1.0":
        return FaceState.NORMAL;
        break;
      default:
        return FaceState.SMILE;
        break;
    }
  }

  void _slideAnimListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
//      _slideAnimController.reset();
      _slideAnimController.removeStatusListener(_slideAnimListener);
      if (_getSliderState(faceState: _currentFaceState) <
          _getSliderState(faceState: _preFaceState))
        _slideAnim =
            Tween(begin: 50.0, end: 00.0).animate(_slideAnimController);
      else
        _slideAnim =
            Tween(begin: -50.0, end: 0.0).animate(_slideAnimController);

      switch (_currentFaceState) {
        case FaceState.ANGRY:
          _currentRatingState = _ratingStates[0];
          break;
        case FaceState.NORMAL:
          _currentRatingState = _ratingStates[1];
          break;
        default:
          _currentRatingState = _ratingStates[2];
          break;
      }

      _slideAnimController.forward(from: 0.0);
      _opacityAnimController.reverse(from: 1.0);
    }
  }
}

class LipsPainter extends CustomPainter {
  double _animValue;

  Offset _startCoordinate = Offset(0, 52.5);

  Offset _control1Coordinate = Offset(48.25, 60);
  Offset _end1Coordinate = Offset(52.5, 60);

  Offset _control2Coordinate = Offset(142.5, 65.25);
  Offset _end2Coordinate = Offset(150, 63.75);

  Offset _startFactor,
      _end1Factor,
      _end2Factor,
      _control1Factor,
      _control2Factor;

  LipsPainter(this._animValue);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if ((_currentFaceState == FaceState.ANGRY &&
            _preFaceState == FaceState.NORMAL) ||
        (_currentFaceState == FaceState.NORMAL &&
            _preFaceState == FaceState.ANGRY)) {
      _startFactor = Offset(_animValue / 3, _animValue);
      _control1Factor = Offset(-_animValue / 4, -_animValue / 15);
      _end1Factor = Offset(0, _animValue / 3.75);

      _control2Factor = Offset(-_animValue, -_animValue / 1.5);
      _end2Factor = Offset(-_animValue / 3, _animValue / 3.75);
    } else if ((_currentFaceState == FaceState.SMILE &&
            _preFaceState == FaceState.NORMAL) ||
        (_currentFaceState == FaceState.NORMAL &&
            _preFaceState == FaceState.SMILE)) {
      _startFactor = Offset(_animValue / 4.5, -_animValue / 1.5);
      _control1Factor = Offset(-_animValue / 1.5, _animValue / 3.5);
      _end1Factor = Offset(_animValue / 3, _animValue / 1.5);

      _control2Factor = Offset(-_animValue, _animValue * 1.5);
      _end2Factor = Offset(-_animValue / 4.5, -_animValue / 2.25);
    }

    canvas.drawPath(
        Path()
          ..moveTo(_startCoordinate.dx + _startFactor.dx,
              _startCoordinate.dy + _startFactor.dy)
          ..quadraticBezierTo(
              _control1Coordinate.dx + _control1Factor.dx,
              _control1Coordinate.dy + _control1Factor.dy,
              _end1Coordinate.dx + _end1Factor.dx,
              _end1Coordinate.dy + _end1Factor.dy)
          ..quadraticBezierTo(
              _control2Coordinate.dx + _control2Factor.dx,
              _control2Coordinate.dy + _control2Factor.dy,
              _end2Coordinate.dx + _end2Factor.dx,
              _end2Coordinate.dy + _end2Factor.dy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..isAntiAlias = true
          ..color = Colors.black);
  }
}

class EyePainter extends CustomPainter {
  double _animValue;

  Offset _startCoordinate = Offset(5, 40);

  Offset _control1Coordinate = Offset(35, 33);
  Offset _end1Coordinate = Offset(65, 30);

  Offset _control2Coordinate = Offset(60, 60);
  Offset _end2Coordinate = Offset(20, 60);

  Offset _control3Coordinate = Offset(0, 50);
  Offset _end3Coordinate = Offset(5, 40);

  Offset _startFactor,
      _control1Factor,
      _end1Factor,
      _control2Factor,
      _end2Factor,
      _control3Factor,
      _end3Factor;

  EyePainter(this._animValue);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if ((_currentFaceState == FaceState.ANGRY &&
            _preFaceState == FaceState.NORMAL) ||
        (_currentFaceState == FaceState.NORMAL &&
            _preFaceState == FaceState.ANGRY)) {
      _startFactor = Offset(0, -_animValue / 3);
      _control1Factor = Offset(0, -_animValue / 20);
      _end1Factor = Offset(0, -_animValue / 5);

      _control2Factor = Offset(-_animValue / 10, _animValue / 5);
      _end2Factor = Offset(_animValue / 3, _animValue / 4);

      _control3Factor = Offset(_animValue / 4, _animValue / 4);
      _end3Factor = Offset(0, -_animValue / 3);
    } else if ((_currentFaceState == FaceState.SMILE &&
            _preFaceState == FaceState.NORMAL) ||
        (_currentFaceState == FaceState.NORMAL &&
            _preFaceState == FaceState.SMILE)) {
      _startFactor = Offset(_animValue / 2, _animValue / 5);

      _control1Factor = Offset(-_animValue / 2, -_animValue * 1.5);
      _end1Factor = Offset(-_animValue / 1.5, -_animValue / 3);

      _control2Factor = Offset(_animValue / 1.5, -_animValue / 2);
      _end2Factor = Offset(_animValue * 1.4, _animValue / 2);

      _control3Factor = Offset(_animValue, _animValue * 1.6);
      _end3Factor = Offset(_animValue / 2, _animValue / 2);
    }

    Path eyePath = Path()
      ..moveTo(_startCoordinate.dx + _startFactor.dx,
          _startCoordinate.dy + _startFactor.dy)
      ..quadraticBezierTo(
          _control1Coordinate.dx + _control1Factor.dx,
          _control1Coordinate.dy + _control1Factor.dy,
          _end1Coordinate.dx + _end1Factor.dx,
          _end1Coordinate.dy + _end1Factor.dy)
      ..quadraticBezierTo(
          _control2Coordinate.dx + _control2Factor.dx,
          _control2Coordinate.dy + _control2Factor.dy,
          _end2Coordinate.dx + _end2Factor.dx,
          _end2Coordinate.dy + _end2Factor.dy)
      ..quadraticBezierTo(
          _control3Coordinate.dx + _control3Factor.dx,
          _control3Coordinate.dy + _control3Factor.dy,
          _end3Coordinate.dx + _end3Factor.dx,
          _end3Coordinate.dy + _end3Factor.dy)
      ..close();

    canvas.drawPath(
        eyePath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 10
          ..isAntiAlias = true
          ..color = Colors.black);
    canvas.drawPath(
        eyePath,
        Paint()
          ..style = PaintingStyle.fill
          ..isAntiAlias = true
          ..color = Colors.white);

    canvas.drawCircle(
        Offset(size.width / 2, 5 * size.height / 8),
        6,
        Paint()
          ..style = PaintingStyle.fill
          ..isAntiAlias = true
          ..color = Colors.black);
  }
}

class CustomSliderThumb extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0, 0);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    var thumbRect = Rect.fromCenter(center: center, height: 50, width: 50);

    var thumbRRect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(thumbRect.left, thumbRect.top),
        Offset(thumbRect.right, thumbRect.bottom),
      ),
      Radius.circular(15),
    );

    var canvas = context.canvas;
    canvas.drawRRect(
        thumbRRect,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke);

    canvas.drawCircle(
        center,
        5,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill);
  }
}

enum FaceState { ANGRY, NORMAL, SMILE }
