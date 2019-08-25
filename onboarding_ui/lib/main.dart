import 'package:flutter/material.dart';
import 'package:onboarding_ui/scope.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingUi(),
    );
  }
}

double _circleY, _minCircleX, _maxCircleX = 140000;
double _minCircleRadius = 40, _contentWidth = 200;

List<int> _colors = [0xff896978, 0xffaeadf0, 0xff45f0df];
List<String> _text = [
  "Flutter is Fun",
  "Flutter is Fantastic",
  "Flutter is Fabulous"
];
int _currentColorPos = 0, _currentTextPos = 0;

class OnboardingUi extends StatefulWidget {
  @override
  _OnboardingUiState createState() => _OnboardingUiState();
}

class _OnboardingUiState extends State<OnboardingUi>
    with TickerProviderStateMixin {
  AnimationController _forwardAnimController,
      _reverseAnimController,
      _arrowOpacityAnimController,
      _slideInAnimController,
      _slideOutAnimController;

  Animation<double> _forwardAnim,
      _reverseAnim,
      _opacityAnim,
      _slideInAnim,
      _slideOutAnim;

  Scope _model;

  @override
  void initState() {
    super.initState();

    _model = Scope();

    _model.bgColor = Color(_colors[_currentColorPos]);

    _forwardAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _reverseAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _arrowOpacityAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideInAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideOutAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _opacityAnim = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _arrowOpacityAnimController,
        curve: Curves.fastLinearToSlowEaseIn));

    _forwardAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _model.changeBgColor(
            Color(_colors[(_currentColorPos + 1) % _colors.length]));
        _reverseAnimController.forward(from: 0.0);

        _currentTextPos++;
      }
    });

    _reverseAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentColorPos++;
        _arrowOpacityAnimController.reverse();
      }
    });

    _arrowOpacityAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _slideInAnimController.forward(from: 0.0);
    });

    _slideOutAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _model.changeSlideState(_slideInAnim);
    });
  }

  @override
  void dispose() {
    _arrowOpacityAnimController.dispose();
    _forwardAnimController.dispose();
    _reverseAnimController.dispose();
    _slideInAnimController.dispose();
    _slideOutAnimController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    _circleY = height - 150;

    var width = MediaQuery.of(context).size.width;
    _minCircleX = width / 2;

    _forwardAnim = Tween<double>(begin: _minCircleX, end: _maxCircleX).animate(
        CurvedAnimation(
            parent: _forwardAnimController, curve: Curves.easeInExpo));

    _reverseAnim = Tween<double>(begin: -_maxCircleX, end: _minCircleX).animate(
        CurvedAnimation(
            parent: _reverseAnimController, curve: Curves.easeOutExpo));

    _slideOutAnim = Tween(begin: width / 2 - _contentWidth / 2, end: -width)
        .animate(_slideOutAnimController);

    _slideInAnim = Tween(begin: width * 2, end: width / 2 - _contentWidth / 2)
        .animate(_slideInAnimController);

    _model.slideAnim = _slideOutAnim;

    return ScopedModel(
      model: _model,
      child: ScopedModelDescendant<Scope>(
        builder: (_, __, model) {
          return Scaffold(
            backgroundColor: model.bgColor,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _forwardAnim,
                    builder: (_, __) {
                      return CustomPaint(
                        foregroundPainter: AnimatedCircle(
                            centerX: _forwardAnim.value,
                            color: _colors[
                                (_currentColorPos + 1) % _colors.length],
                            circleType: CircleType.FORWARD),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _reverseAnim,
                    builder: (_, __) {
                      return CustomPaint(
                        foregroundPainter: AnimatedCircle(
                            centerX: _reverseAnim.value,
                            color: _colors[(_currentColorPos) % _colors.length],
                            circleType: CircleType.REVERSE),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!(_forwardAnimController.isAnimating ||
                          _reverseAnimController.isAnimating ||
                          _arrowOpacityAnimController.isAnimating)) {
                        _model.changeSlideState(_slideOutAnim);
                        _slideOutAnimController.forward(from: 0.0);

                        _forwardAnimController.forward(from: 0.0);
                        _arrowOpacityAnimController.forward(from: 0.0);
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _opacityAnim,
                      builder: (_, __) {
                        double arrowSize = 13.0;

                        return Opacity(
                          opacity: _opacityAnim.value,
                          child: Container(
                            color: Colors.transparent,
                            margin: EdgeInsets.only(
                                top: _circleY - _minCircleRadius),
                            padding: EdgeInsets.all(
                                _minCircleRadius - arrowSize / 2),
                            child: ScopedModelDescendant<Scope>(
                                builder: (_, __, model) {
                              return Icon(
                                Icons.arrow_forward_ios,
                                size: arrowSize,
                                color: model.bgColor,
                              );
                            }),
                            alignment: Alignment.topCenter,
                          ),
                        );
                      },
                    ),
                  ),
                  ScopedModelDescendant<Scope>(
                    builder: (_, __, model) {
                      return AnimatedBuilder(
                        animation: model.slideAnim,
                        builder: (_, __) {
                          return Transform.translate(
                            offset: Offset(
                                model.slideAnim.value,
                                height / 2 -
                                    _contentWidth),
                            child: Opacity(
                                opacity: 1,
                                child: Container(
                                  width: _contentWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FlutterLogo(
                                        size: _contentWidth / 2,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Flexible(
                                        child: Text(
                                          _text[_currentTextPos % _text.length],
                                          textAlign: TextAlign.center,
                                          style: _getTextStyle(40),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    alignment: Alignment.topRight,
                    child: Text(
                      "Skip",
                      style: _getTextStyle(15),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle _getTextStyle(double fontSize) {
    return TextStyle(
        fontFamily: "Cabin",
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: fontSize);
  }
}

class AnimatedCircle extends CustomPainter {
  double centerX;
  int color;
  CircleType circleType;

  AnimatedCircle({this.centerX, this.color, this.circleType});

  @override
  void paint(Canvas canvas, Size size) {
    var radius = _minCircleRadius + centerX - _minCircleX;
    var innerRadius;

    if (circleType == CircleType.REVERSE) {
      radius = radius.abs();

      //to avoid radius turning less than minimum radius
      if (radius <= _minCircleRadius) {
        innerRadius = radius;
        radius = _minCircleRadius;
      }
    }

    canvas.drawCircle(
        Offset(centerX, _circleY), radius, Paint()..color = Color(color));

    //inner circle animation
    if (innerRadius != 0) {
      canvas.drawCircle(
          Offset(centerX, _circleY),
          innerRadius,
          Paint()
            ..color = Color(_colors[(_currentColorPos + 1) % _colors.length]));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum CircleType { FORWARD, REVERSE }