import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessageSend(),
    );
  }
}

class MessageSend extends StatefulWidget {
  @override
  _MessageSendState createState() => _MessageSendState();
}

Color _theme = Colors.cyan;
double _tickDuration = 100, _tickMidPoint = _tickDuration / 2;

class _MessageSendState extends State<MessageSend>
    with TickerProviderStateMixin {
  Animation<double> _buttonAnim, _loadingAnim, _flyAnim, _tickAnim;
  AnimationController _buttonAnimCont,
      _loadingAnimCont,
      _flyAnimCont,
      _tickAnimCont;

  int _loadAnimPos = 0, _currentState = 0, _loadingDotCount = 3;

  @override
  void initState() {
    super.initState();

    _buttonAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _loadingAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 90));
    _flyAnimCont = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _tickAnimCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _buttonAnim = Tween(begin: 0.0, end: 50.0).animate(_buttonAnimCont);
    _tickAnim = Tween(begin: 0.0, end: _tickDuration).animate(_tickAnimCont);
    _loadingAnim = Tween(begin: 0.0, end: -6.0).animate(_loadingAnimCont);
    _flyAnim = Tween(begin: 0.0, end: -1000.0).animate(_flyAnimCont);

    _buttonAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentState = 1;
          _loadingAnimCont.forward();
          _flyAnimCont.forward(from: 0.0);
        });
      }
    });

    _flyAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        setState(() {
          _currentState = 2;
          _loadingAnimCont.stop();
          _tickAnimCont.forward(from: 0.0);
        });
    });

    _tickAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        var entry = OverlayEntry(builder: (_) {
          return Positioned(
            top: 30,
            right: 20,
            left: 20,
            child: Material(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0x44336699),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Message sent!",
                    style: TextStyle(
                        fontFamily: "fonts/Cabin",
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.white),
                  )),
            ),
          );
        });
        Overlay.of(context).insert(entry);
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            entry.remove();
            entry = null;
            _currentState = 0;
            _buttonAnimCont.reverse();
          });
        });
      }
    });

    _loadingAnimCont.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _loadAnimPos = ++_loadAnimPos % _loadingDotCount;
        _loadingAnimCont.forward();
      } else if (status == AnimationStatus.completed)
        _loadingAnimCont.reverse();
    });
  }

  @override
  void dispose() {
    _loadingAnimCont.dispose();
    _buttonAnimCont.dispose();
    _flyAnimCont.dispose();
    _tickAnimCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedBuilder(
              animation: _flyAnim,
              builder: (_, __) {
                return Visibility(
                  visible: _flyAnim.value != 0,
                  child: Transform.translate(
                      offset: Offset(0.0, _flyAnim.value),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Transform.rotate(
                            angle: pi / 180 * -90,
                            child: Icon(
                              Icons.send,
                              size: 30,
                              color: _theme,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Opacity(
                            opacity: _flyAnimCont.value / 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  width: 2,
                                  height: 20,
                                  color: _theme,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 2,
                                  height: 12,
                                  color: _theme,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  width: 2,
                                  height: 20,
                                  color: _theme,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                );
              }),
          AnimatedBuilder(
            animation: _buttonAnim,
            builder: (_, __) {
              return GestureDetector(
                onTap: () {
                  if (_currentState == 0) _buttonAnimCont.forward();
                },
                child: Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    height: 50,
                    width: 50 + _buttonAnim.value,
                    decoration: BoxDecoration(
                        color: _theme,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: IndexedStack(
                      index: _currentState,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Transform.rotate(
                          angle: pi / 180 * -45,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        AnimatedBuilder(
                            animation: _loadingAnim,
                            builder: (_, __) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  for (int pos = 0;
                                      pos < _loadingDotCount;
                                      pos++)
                                    Transform.translate(
                                      offset: Offset(
                                          0,
                                          _loadAnimPos == pos
                                              ? _loadingAnim.value
                                              : 0.0),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 2, right: 2),
                                        height: 4,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                      ),
                                    )
                                ],
                              );
                            }),
                        AnimatedBuilder(
                          animation: _tickAnim,
                          builder: (_, __) {
                            return SizedBox(
                              width: 15,
                              height: 10,
                              child: CustomPaint(
                                painter: TickPainter(_tickAnim.value),
                              ),
                            );
                          },
                        )
                      ],
                    )),
              );
            },
          ),
        ],
      ),
    ));
  }
}

class TickPainter extends CustomPainter {
  double _animValue;

  TickPainter(this._animValue);

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()..moveTo(0, size.height / 2);

    if (_animValue < _tickMidPoint)
      path.lineTo(0 + (size.width / 3 / _tickMidPoint * _animValue),
          size.height / 2 + (size.height / 2 / _tickMidPoint * _animValue));
    else
      path.lineTo(size.width / 3, size.height);

    if (_animValue >= _tickMidPoint)
      path.lineTo(
          size.width / 3 +
              (2 *
                  size.width /
                  3 /
                  _tickMidPoint *
                  (_animValue - _tickMidPoint)),
          size.height -
              (size.height / _tickMidPoint * (_animValue - _tickMidPoint)));

    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
