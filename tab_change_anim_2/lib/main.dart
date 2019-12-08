import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      home: TabAnim(),
      debugShowCheckedModeBanner: false,
    ));

class TabAnim extends StatefulWidget {
  @override
  _TabAnimState createState() => _TabAnimState();
}

class _TabAnimState extends State<TabAnim> with TickerProviderStateMixin {
  AnimationController _animCont;
  Animation<double> _textAnim, _iconAnim, _overlayAnim;
  Animation<double> _textRevAnim, _iconRevAnim, _overlayRevAnim;
  Animation<double> _textNoAnim, _iconNoAnim, _overlayNoAnim;

  var _selectedPos = -1, _prevPos = -1;
  var _overlayWidth = 60.0;
  var color = Colors.deepPurple;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    var textStartValue = -15.0, textEndValue = 20.0;
    var iconStartValue = -50.0, iconEndValue = -10.0;
    var overlayStartValue = iconStartValue - 10.0,
        overlayEndValue = textEndValue;

    _animCont =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    var curve = CurvedAnimation(curve: Curves.easeInCubic, parent: _animCont);

    _textAnim = Tween(begin: textStartValue, end: textEndValue).animate(curve);
    _iconAnim = Tween(begin: iconStartValue, end: iconEndValue).animate(curve);
    _overlayAnim =
        Tween(begin: overlayStartValue, end: overlayEndValue).animate(curve);

    _textRevAnim =
        Tween(end: textStartValue, begin: textEndValue).animate(curve);
    _iconRevAnim =
        Tween(end: iconStartValue, begin: iconEndValue).animate(curve);
    _overlayRevAnim =
        Tween(end: overlayStartValue, begin: overlayEndValue).animate(curve);

    _textNoAnim = Tween(begin: textEndValue, end: textEndValue).animate(curve);
    _iconNoAnim = Tween(begin: iconEndValue, end: iconEndValue).animate(curve);
    _overlayNoAnim =
        Tween(begin: overlayEndValue, end: overlayEndValue).animate(curve);
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  Widget _getRowItem(int tabPos, String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (tabPos != _prevPos && !_animCont.isAnimating) {
          _selectedPos = _prevPos;
          _prevPos = tabPos;
          _animCont.forward(from: 0.0);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _isNoAnim(tabPos)
                          ? _iconNoAnim
                          : _isRevAnim(tabPos) ? _iconRevAnim : _iconAnim,
                      builder: (_, __) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Transform.translate(
                              offset: Offset(
                                  0.0,
                                  _isNoAnim(tabPos)
                                      ? _iconNoAnim.value
                                      : _isRevAnim(tabPos)
                                          ? _iconRevAnim.value
                                          : _iconAnim.value),
                              child: Icon(
                                icon,
                                color: color,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(
                                  0.0,
                                  _isNoAnim(tabPos)
                                      ? _overlayNoAnim.value
                                      : _isRevAnim(tabPos)
                                          ? _overlayRevAnim.value
                                          : _overlayAnim.value),
                              child: SizedBox(
                                  width: _overlayWidth,
                                  height: 35,
                                  child: CustomPaint(
                                    painter: OverlayPainter(),
                                  )),
                            ),
                          ],
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _isNoAnim(tabPos)
                          ? _textNoAnim
                          : _isRevAnim(tabPos) ? _textRevAnim : _textAnim,
                      builder: (_, __) {
                        return Transform.translate(
                          offset: Offset(
                              0.0,
                              _isNoAnim(tabPos)
                                  ? _textNoAnim.value
                                  : _isRevAnim(tabPos)
                                      ? _textRevAnim.value
                                      : _textAnim.value),
                          child: Text(
                            text,
                            style: TextStyle(
                                color: color,
                                fontFamily: "Khula",
                                fontWeight: FontWeight.w700),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      width: _overlayWidth,
                      height: 30,
                      child: CustomPaint(
                        painter: OverlayPainter(),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animCont,
                      builder: (_, __) {
                        return Transform.scale(
                          alignment: Alignment.bottomCenter,
                          scale: _isNoAnim(tabPos)
                              ? 0
                              : _isRevAnim(tabPos)
                                  ? _animCont.value
                                  : 1 - _animCont.value,
                          child: Align(
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isNoAnim(int tabPos) {
    return tabPos != _selectedPos && tabPos != _prevPos;
  }

  bool _isRevAnim(int tabPos) {
    return tabPos == _prevPos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FlutterLogo(
            size: 90,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _getRowItem(0, "Events", Icons.event_note),
                  _getRowItem(1, "Search", Icons.search),
                  _getRowItem(2, "Gallery", Icons.photo),
                  _getRowItem(3, "Settings", Icons.tune),
                ],
              )),
        ],
      ),
    );
  }
}

class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()
          ..lineTo(size.width, size.height / 3.5)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close(),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
