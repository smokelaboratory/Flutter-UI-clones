import 'package:flutter/material.dart';

class SwipeToRespondWidget extends StatefulWidget {
  final Function(ResponseType) onSwipe;

  SwipeToRespondWidget(this.onSwipe);

  @override
  _SwipeToRespondWidgetState createState() => _SwipeToRespondWidgetState();
}

double _slideRange = 200.0;
int _slideAnimDuration = 500;
double _buttonSize = 30.0;
double _itemHeight = 100.0;
Color _bondColor = Colors.blueAccent;

class _SwipeToRespondWidgetState extends State<SwipeToRespondWidget>
    with TickerProviderStateMixin {
  Animation _slideAnim, _bondAnim, _iconOpacityAnim, _collapseAnim;
  AnimationController _slideAnimController,
      _bondAnimController,
      _collapseAnimController,
      _iconOpacityAnimController;

  ResponseType _responseType;

  @override
  void initState() {
    super.initState();

    _slideAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _slideAnimDuration));
    _bondAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _slideAnimDuration));
    _iconOpacityAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _collapseAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _collapseAnim =
        Tween(begin: _itemHeight, end: 0.0).animate(_collapseAnimController);
    _slideAnim = Tween(begin: -_slideRange, end: _slideRange)
        .animate(_slideAnimController);
    _bondAnim = Tween(begin: -_slideRange, end: _slideRange)
        .animate(_bondAnimController);
    _iconOpacityAnim =
        Tween(begin: 1.0, end: 0.0).animate(_iconOpacityAnimController);

    _collapseAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onSwipe(_responseType);
    });

    _iconOpacityAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _collapseAnimController.forward();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bondAnimController.value = 0.5;
      _slideAnimController.value = 0.5;
    });
  }

  @override
  void dispose() {
    _collapseAnimController.dispose();
    _iconOpacityAnimController.dispose();
    _bondAnimController.dispose();
    _slideAnimController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _collapseAnim,
        builder: (_, __) {
          return AnimatedBuilder(
            animation: _slideAnim,
            builder: (_, __) {
              return SizedBox(
                height: _collapseAnim.value,
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _bondAnim,
                      builder: (_, __) {
                        return Visibility(
                          visible: _responseType != null
                              ? _responseType == ResponseType.REJECT
                              : true,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: _itemHeight,
                              child: CustomPaint(
                                painter: BondPainter(
                                    _bondAnim.value -
                                        _buttonSize -
                                        _bondAnim.value / 2,
                                    BondType.LEFT),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                        animation: _iconOpacityAnim,
                        builder: (_, __) {
                          return Visibility(
                            visible: _responseType != null
                                ? _responseType == ResponseType.REJECT
                                : true,
                            child: Opacity(
                              opacity: _iconOpacityAnim.value,
                              child: Transform.scale(
                                scale: _iconOpacityAnim.value,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Transform.translate(
                                      offset: Offset(
                                          _slideAnim.value -
                                              _buttonSize -
                                              _slideAnim.value / 2,
                                          0.0),
                                      child:
                                          ResponseButton(ResponseType.REJECT),
                                    )),
                              ),
                            ),
                          );
                        }),
                    GestureDetector(
                      onHorizontalDragUpdate: (data) {
                        _slideAnimController.value +=
                            data.primaryDelta / _slideRange * 2;
                        _bondAnimController.value = _slideAnimController.value;
                      },
                      onHorizontalDragEnd: (data) {
                        if (_slideAnimController.value == 0.0) {
                          _responseType = ResponseType.ACCEPT;

                          _slideAnimController.reverse(
                              from: _slideAnimController.value);
                          _bondAnimController.forward(
                              from: _bondAnimController.value);
                          _iconOpacityAnimController.forward(
                              from: _iconOpacityAnimController.value);
                        } else if (_slideAnimController.value == 1.0) {
                          _responseType = ResponseType.REJECT;

                          _slideAnimController.forward(
                              from: _slideAnimController.value);
                          _bondAnimController.reverse(
                              from: _bondAnimController.value);
                          _iconOpacityAnimController.forward(
                              from: _iconOpacityAnimController.value);
                        } else{
                          _bondAnimController.animateTo(0.5);
                          _slideAnimController.animateTo(0.5);
                        }
                      },
                      child: Opacity(
                        opacity: _getOpacity(),
                        child: Transform.translate(
                          offset: Offset(_slideAnim.value, 0),
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            color: Colors.white,
                            child: Container(
                              height: _itemHeight,
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            FlutterLogo(
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            TextWidget("Flutter is awesome!",
                                                FontWeight.w700),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextWidget(
                                          "It is one of the best things happend to technology",
                                          FontWeight.w300,
                                          lineSpace: 0.7,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextWidget(
                                          "23 Sep", FontWeight.w700,
                                          color: Colors.grey),
                                    ),
                                    flex: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                        animation: _iconOpacityAnim,
                        builder: (_, __) {
                          return Visibility(
                            visible: _responseType != null
                                ? _responseType == ResponseType.ACCEPT
                                : true,
                            child: Opacity(
                              opacity: _iconOpacityAnim.value,
                              child: Transform.scale(
                                scale: _iconOpacityAnim.value,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Transform.translate(
                                      offset: Offset(
                                          _slideAnim.value +
                                              _buttonSize -
                                              _slideAnim.value / 2,
                                          0.0),
                                      child:
                                          ResponseButton(ResponseType.ACCEPT),
                                    )),
                              ),
                            ),
                          );
                        }),
                    AnimatedBuilder(
                      animation: _bondAnim,
                      builder: (_, __) {
                        return Visibility(
                          visible: _responseType != null
                              ? _responseType == ResponseType.ACCEPT
                              : true,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: _itemHeight,
                              child: CustomPaint(
                                painter: BondPainter(
                                    _bondAnim.value +
                                        _buttonSize -
                                        _bondAnim.value / 2,
                                    BondType.RIGHT),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  double _getOpacity() {
    return _slideAnimController.value > 0.5
        ? 1 - (_slideAnimController.value - 0.5) * 2
        : _slideAnimController.value * 2;
  }
}

class BondPainter extends CustomPainter {
  double offset;
  BondType _bondType;
  double _stretchCurveRadius, _nodeRadius;

  BondPainter(this.offset, this._bondType) {
    _stretchCurveRadius = offset.abs() + _itemHeight / 5;
    _nodeRadius = 8;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        _bondType == BondType.RIGHT
            ? (Path()
              ..moveTo(size.width, 0)
              ..lineTo(size.width, size.height)
              ..arcToPoint(
                  Offset(
                      size.width + offset, size.height / 2 + _buttonSize / 4),
                  radius: Radius.circular(_stretchCurveRadius),
                  clockwise: false)
              ..arcToPoint(
                  Offset(
                      size.width + offset, size.height / 2 - _buttonSize / 4),
                  radius: Radius.circular(_nodeRadius))
              ..arcToPoint(Offset(size.width, 0),
                  radius: Radius.circular(_stretchCurveRadius),
                  clockwise: false))
            : (Path()
              ..lineTo(0, size.height)
              ..arcToPoint(
                  Offset(0 + offset, size.height / 2 + _buttonSize / 4),
                  radius: Radius.circular(_stretchCurveRadius))
              ..arcToPoint(
                  Offset(0 + offset, size.height / 2 - _buttonSize / 4),
                  radius: Radius.circular(_nodeRadius),
                  clockwise: false)
              ..arcToPoint(
                Offset(0, 0),
                radius: Radius.circular(_stretchCurveRadius),
              )),
        Paint()
          ..style = PaintingStyle.fill
          ..color = _bondColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ResponseButton extends StatelessWidget {
  final ResponseType _buttonType;
  final double _radius = 15;

  ResponseButton(this._buttonType);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(_radius)),
      child: Container(
        padding: EdgeInsets.all(_buttonSize / 4),
        decoration: BoxDecoration(
            color: _bondColor,
            borderRadius: BorderRadius.all(Radius.circular(_radius))),
        child: Icon(
            _buttonType == ResponseType.ACCEPT ? Icons.check : Icons.close,
            color: Colors.white,
            size: _buttonSize / 2),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  final String _text;
  double lineSpace, fontSize;
  final FontWeight _fontWeight;
  final Color color;

  TextWidget(this._text, this._fontWeight,
      {this.lineSpace = 1, this.color = Colors.black, this.fontSize = 15});

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
          fontSize: fontSize,
          height: lineSpace,
          fontFamily: "Khula",
          fontWeight: _fontWeight,
          color: color),
    );
  }
}

enum BondType { LEFT, RIGHT }
enum ResponseType { ACCEPT, REJECT }
