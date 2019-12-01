import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabAnim(),
    ));

class TabAnim extends StatefulWidget {
  @override
  _TabAnimState createState() => _TabAnimState();
}

class _TabAnimState extends State<TabAnim> with TickerProviderStateMixin {
  GlobalKey _icon1Key, _icon2Key, _icon3Key, _icon4Key, _icon5Key;
  Animation<double> _animIndicator, _animIcon;
  AnimationController _animCont;

  double _lastTabIconPosition = 0.0,
      _newtabIconPosition = 0.0,
      _indicatorSize = 35,
      _textSize = 12.0;

  bool _isReverse = false;

  GlobalKey _animKey;

  double _indicatorYOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _icon1Key = GlobalKey();
    _icon2Key = GlobalKey();
    _icon3Key = GlobalKey();
    _icon4Key = GlobalKey();
    _icon5Key = GlobalKey();

    _animCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animIndicator = Tween(begin: 0.0, end: 0.0).animate(_animCont);
    _animIcon = Tween(begin: 0.0, end: pi / 180 * 360).animate(_animCont);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _lastTabIconPosition = _getTabIconPosition(_icon1Key, isStart: true);
        _animIndicator =
            Tween(begin: _lastTabIconPosition, end: 0.0).animate(_animCont);
      });
    });
  }

  double _getTabIconPosition(GlobalKey key, {bool isStart = false}) {
    var renderObject = key.currentContext.findRenderObject() as RenderBox;

    if (isStart) _indicatorYOffset = -_textSize / 2-2;

    return renderObject.localToGlobal(Offset.zero).dx +
        renderObject.size.width / 2 -
        _indicatorSize / 2;
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  Widget _getTabIcon(GlobalKey iconKey, IconData icon, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animIcon,
          builder: (_, __) {
            return Transform.rotate(
              angle: iconKey == _animKey ? _animIcon.value : 0.0,
              child: Transform.scale(
                scale: iconKey == _animKey
                    ? min(sin(_animIcon.value / 2), 0.6) + 1
                    : 1,
                child: IconButton(
                  key: iconKey,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (!_animCont.isAnimating) {
                      _animKey = iconKey;
                      _newtabIconPosition = _getTabIconPosition(iconKey);
                      _animCont.reset();
                      _isReverse = _newtabIconPosition < _lastTabIconPosition;
                      _animIndicator = Tween(
                              begin: _lastTabIconPosition,
                              end: _newtabIconPosition)
                          .animate(CurvedAnimation(
                              curve: Curves.easeOutBack, parent: _animCont));
                      _animCont.forward();
                      _lastTabIconPosition = _newtabIconPosition;
                    }
                  },
                  icon: Icon(
                    icon,
                    color: Color(0x99000000),
                    size: _indicatorSize * 0.7,
                  ),
                ),
              ),
            );
          },
        ),
        Text(
          title,
          style: TextStyle(fontSize: _textSize, fontFamily: "Cabin"),
        )
      ],
    );
  }

  bool _isEliptical() {
    return _animCont.value > 0.0 && _animCont.value < 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FlutterLogo(
            size: 80,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(
                  height: 0.5,
                  color: Colors.black26,
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _animIndicator,
                      builder: (_, __) {
                        return Transform.translate(
                          offset:
                              Offset(_animIndicator.value, _indicatorYOffset),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: _isReverse
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    end: _isReverse
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    colors: [
                                      _isEliptical()
                                          ? Colors.white
                                          : Colors.yellow,
                                      Colors.yellow
                                    ]),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(_indicatorSize / 2))),
                            height: _indicatorSize,
                            width: _indicatorSize * (_isEliptical() ? 1.2 : 1),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _getTabIcon(_icon1Key, Icons.home, "Home"),
                          _getTabIcon(_icon2Key, Icons.account_balance_wallet,
                              "Wallet"),
                          _getTabIcon(
                              _icon3Key, Icons.account_balance, "Account"),
                          _getTabIcon(_icon4Key, Icons.notifications, "Notice"),
                          _getTabIcon(
                              _icon5Key, Icons.account_circle, "Profile")
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
