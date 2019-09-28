import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuInteraction(),
      debugShowCheckedModeBanner: false,
    );
  }
}

double _btSize = 50.0;
double _frameSize = 200.0;
double _clickAreaSize = 20.0;

class MenuInteraction extends StatefulWidget {
  @override
  _MenuInteractionState createState() => _MenuInteractionState();
}

class _MenuInteractionState extends State<MenuInteraction>
    with TickerProviderStateMixin {
  Animation<double> _expandAnim, _mergeAnim, _divergeAnim, _scaleOpacAnim;
  AnimationController _expandAnimController,
      _mergeAnimController,
      _scaleOpacAnimController,
      _divergeAnimController;

  @override
  void initState() {
    super.initState();

    _expandAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _mergeAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _divergeAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _scaleOpacAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _expandAnim =
        Tween(begin: 0.0, end: _frameSize).animate(_expandAnimController);

    _mergeAnim = Tween(begin: 5.0, end: 0.0).animate(_mergeAnimController);

    _divergeAnim =
        Tween(begin: 0.0, end: pi / 180 * 40).animate(_divergeAnimController);

    _scaleOpacAnim =
        Tween(begin: 0.0, end: 1.0).animate(_scaleOpacAnimController);

    _mergeAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _expandAnimController.forward(from: _expandAnimController.value);
    });

    _expandAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _divergeAnimController.forward(from: _divergeAnimController.value);
      else if (status == AnimationStatus.dismissed)
        _mergeAnimController.reverse(from: _mergeAnimController.value);
    });

    _divergeAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _scaleOpacAnimController.forward(from: _scaleOpacAnimController.value);
      else if (status == AnimationStatus.dismissed)
        _expandAnimController.reverse(from: _expandAnimController.value);
    });

    _scaleOpacAnimController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed)
        _divergeAnimController.reverse(from: _expandAnimController.value);
    });
  }

  @override
  void dispose() {
    _expandAnimController.dispose();
    _mergeAnimController.dispose();
    _divergeAnimController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff90aa61),
      body: Center(
        child: SizedBox(
          height: _frameSize + _btSize,
          width: _frameSize + _btSize,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                color: Colors.white,
                height: _frameSize,
                width: _frameSize,
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    borderRadius:
                        BorderRadius.all(Radius.circular(_btSize / 2)),
                    color: Colors.transparent,
                    elevation: 5,
                    child: AnimatedBuilder(
                      animation: _expandAnim,
                      builder: (_, __) {
                        return SizedBox(
                          width: _btSize + _expandAnim.value,
                          height: _btSize,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: _btSize,
                                width: _btSize + _expandAnim.value,
                                decoration: BoxDecoration(
                                    color: Color(0xff424739),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(_btSize / 2))),
                                child: AnimatedBuilder(
                                  animation: _scaleOpacAnim,
                                  builder: (_, __) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        MenuOption(_scaleOpacAnim.value),
                                        MenuOption(_scaleOpacAnim.value),
                                        MenuOption(_scaleOpacAnim.value),
                                        SizedBox(
                                          width: 2,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                left: _btSize / 2 - _clickAreaSize / 2,
                                top: _btSize / 2 - _clickAreaSize / 2,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(_clickAreaSize / 2)),
                                    onTap: () {
                                      if (_mergeAnimController.status ==
                                          AnimationStatus.completed)
                                        _scaleOpacAnimController.reverse();
                                      else
                                        _mergeAnimController.forward();
                                    },
                                    child: Container(
                                      height: _clickAreaSize,
                                      width: _clickAreaSize,
                                      child: AnimatedBuilder(
                                        animation: _mergeAnim,
                                        builder: (_, __) {
                                          return AnimatedBuilder(
                                            animation: _divergeAnim,
                                            builder: (_, __) {
                                              return Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  Transform.translate(
                                                      offset: Offset(
                                                          0, _mergeAnim.value),
                                                      child: Transform.rotate(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        angle:
                                                            _divergeAnim.value,
                                                        child: Container(
                                                          height: 3,
                                                          width: _clickAreaSize -
                                                              5 -
                                                              _divergeAnim
                                                                      .value *
                                                                  5,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                        ),
                                                      )),
                                                  Transform.translate(
                                                    offset: Offset(
                                                        0, -_mergeAnim.value),
                                                    child: Transform.rotate(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      angle:
                                                          -_divergeAnim.value,
                                                      child: Container(
                                                        height: 3,
                                                        width: _clickAreaSize -
                                                            5 -
                                                            _divergeAnim.value *
                                                                5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MenuOption extends StatelessWidget {
  double _animValue;

  MenuOption(this._animValue);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _animValue != 0,
      child: Opacity(
        opacity: _animValue,
        child: Transform.scale(
          scale: _animValue,
          child: Container(
            height: _btSize * 0.7,
            width: _btSize * 0.7,
            decoration: BoxDecoration(
                color: Color(0xff696b60),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ),
    );
  }
}
