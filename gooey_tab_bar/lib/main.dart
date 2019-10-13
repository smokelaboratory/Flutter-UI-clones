import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabButton(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const double _maxDragHeight = 230.0;
const double _bottomMargin = 20.0;
const double _btSize = 60.0;
const Color _themeColor = Color(0xff64c6fa);

class TabButton extends StatefulWidget {
  @override
  _TabButtonState createState() => _TabButtonState();
}

class _TabButtonState extends State<TabButton> with TickerProviderStateMixin {
  AnimationController _dragAnimCont,
      _gooeyAnimCont,
      _opacAnimCont,
      _menuAnimCont,
      _btStyleAnimCont;
  Animation<double> _dragAnim, _gooeyAnim, _opacAnim, _menuAnim;
  Animation<Color> _btBgAnim, _iconAnim;

  double _btDragFactor = 0.0;
  bool _isMaxReached = false;

  @override
  void initState() {
    super.initState();

    var _duration = Duration(milliseconds: 500);

    _dragAnimCont = AnimationController(vsync: this, duration: _duration);
    _btStyleAnimCont = AnimationController(vsync: this, duration: _duration);
    _gooeyAnimCont = AnimationController(vsync: this, duration: _duration);
    _opacAnimCont = AnimationController(vsync: this, duration: _duration);
    _menuAnimCont = AnimationController(vsync: this, duration: _duration);

    _menuAnim = Tween(begin: 0.0, end: 1.0).animate(_menuAnimCont);
    _dragAnim = Tween(begin: 0.0, end: -_maxDragHeight).animate(_dragAnimCont);
    _gooeyAnim =
        Tween(begin: 0.0, end: -_maxDragHeight).animate(_gooeyAnimCont);
    _opacAnim = Tween(begin: 0.0, end: 1.0).animate(_opacAnimCont);
    _iconAnim = ColorTween(begin: Colors.white, end: _themeColor)
        .animate(_btStyleAnimCont);
    _btBgAnim = ColorTween(begin: _themeColor, end: Colors.white)
        .animate(_btStyleAnimCont);

    _gooeyAnimCont.addListener(() {
      if (_gooeyAnimCont.value > 0.8 && _isMaxReached == false) {
        _isMaxReached = true;
        _btStyleAnimCont.forward();
        _menuAnimCont.forward();
        _dragAnimCont.forward(from: _dragAnimCont.value);
        _gooeyAnimCont.reverse(from: _gooeyAnimCont.value);
      }
    });

    _dragAnimCont.addListener(() {
      if (_dragAnimCont.status == AnimationStatus.dismissed) {
        _isMaxReached = false;
        _btDragFactor = 0.0;
      }
    });
  }

  @override
  void dispose() {
    _dragAnimCont.dispose();
    _gooeyAnimCont.dispose();
    _opacAnimCont.dispose();
    _btStyleAnimCont.dispose();
    _menuAnimCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: _opacAnim,
              builder: (_, __) {
                return Opacity(
                  opacity: 1 - _opacAnim.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: _getTv(string: "Flutter",
                              color: Colors.blueAccent,
                              weight: FontWeight.w700,
                              size: 50.0),
                        ),
                      ),
                      Container(
                        //24 is default icon size
                        margin: const EdgeInsets.only(
                            bottom: _bottomMargin + _btSize / 2 - 12),
                        child: Theme(
                          data: ThemeData(
                              iconTheme: IconThemeData(
                                  color: Colors.blueAccent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.image),
                              Icon(Icons.message),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.search),
                              Icon(Icons.add_shopping_cart),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _opacAnim,
              builder: (_, __) {
                return Opacity(
                  opacity: _opacAnim.value,
                  child: AnimatedBuilder(
                    animation: _gooeyAnim,
                    builder: (_, __) {
                      return SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: CustomPaint(
                          painter: GooeyPainter(_gooeyAnim.value),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _dragAnim,
              builder: (_, __) {
                return Container(
                  margin: const EdgeInsets.only(bottom: _bottomMargin),
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(0.0, _dragAnim.value),
                    child: GestureDetector(
                        onTap: () {
                          if (_isSafeToAnimate()) {
                            if (_isMaxReached) {
                              _btStyleAnimCont.reverse();
                              _menuAnimCont.reverse();
                              _dragAnimCont.reverse();
                              _opacAnimCont.reverse();
                            } else {
                              _gooeyAnimCont.forward();
                              _dragAnimCont.forward();
                              _opacAnimCont.forward();
                            }
                          }
                        },
                        onVerticalDragStart: (data) {
                          if (!_isMaxReached && _isSafeToAnimate())
                            _opacAnimCont.forward();
                        },
                        onVerticalDragEnd: (data) {
                          if (!_isMaxReached && _isSafeToAnimate()) {
                            _gooeyAnimCont.reverse();
                            _dragAnimCont.reverse();
                            _opacAnimCont.reverse();
                            _btStyleAnimCont.reverse();
                          }
                        },
                        onVerticalDragUpdate: (data) {
                          if (_btDragFactor <= 0 &&
                              _isSafeToAnimate() &&
                              _btDragFactor.abs() <= _maxDragHeight &&
                              !_isMaxReached) {
                            _btDragFactor += data.primaryDelta;
                            _dragAnimCont.value =
                                _btDragFactor.abs() / _maxDragHeight;
                            _gooeyAnimCont.value = _dragAnimCont.value;
                          }
                        },
                        child: AnimatedBuilder(
                            animation: _iconAnim,
                            builder: (_, __) {
                              return AnimatedBuilder(
                                  animation: _btBgAnim,
                                  builder: (_, __) {
                                    return Container(
                                      height: _btSize,
                                      width: _btSize,
                                      decoration: BoxDecoration(
                                          color: _btBgAnim.value,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(_btSize / 2))),
                                      child: Transform.rotate(
                                        angle:
                                        pi / 180 * _btStyleAnimCont.value * 45,
                                        child: Icon(
                                          Icons.add,
                                          color: _iconAnim.value,
                                        ),
                                      ),
                                    );
                                  });
                            })),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _menuAnim,
              builder: (_, __) {
                return Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: _bottomMargin * 1.5),
                  child: Visibility(
                    visible: _isMaxReached,
                    child: Opacity(
                      opacity: _menuAnim.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _getTv(string: "Reminder"),
                          SizedBox(
                            height: 20,
                          ),
                          _getTv(string: "Camera"),
                          SizedBox(
                            height: 20,
                          ),
                          _getTv(string: "Attachment"),
                          SizedBox(
                            height: 20,
                          ),
                          _getTv(string: "Text Note"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ));
  }

  bool _isSafeToAnimate() {
    return !_dragAnimCont.isAnimating;
  }

  Text _getTv(
      {string, color = Colors.white, size = 20.0, weight = FontWeight.w600}) {
    return Text(
      string,
      style: TextStyle(color: color, fontSize: size,
          fontWeight: weight,
          fontFamily: "Khula"),
    );
  }
}

class GooeyPainter extends CustomPainter {
  double _gooeyDragFactor;

  GooeyPainter(this._gooeyDragFactor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = max(_maxDragHeight * 3 / 4, _maxDragHeight + _gooeyDragFactor);
    var height = size.height +
        _gooeyDragFactor -
        (_gooeyDragFactor != 0.0
            ? _bottomMargin
            : 0.0); //to add bottom margin in gooey bg and to remove it in reverse
    var arcGap = -_gooeyDragFactor / 10; //factor is negative

    canvas.drawPath(
        Path()
          ..lineTo(size.width, 0)..lineTo(size.width, size.height)
          ..arcToPoint(Offset(size.width / 2 + arcGap, height),
              radius: Radius.circular(radius))..arcToPoint(
            Offset(size.width / 2 - arcGap, height),
            radius: Radius.circular(1), clockwise: false)..arcToPoint(
          Offset(0, size.height),
          radius: Radius.circular(radius),
        )
          ..close(),
        Paint()
          ..color = _themeColor
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
