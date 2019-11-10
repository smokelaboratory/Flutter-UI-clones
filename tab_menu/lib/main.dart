import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabMenu(),
      theme: ThemeData(fontFamily: "Khula"),
      debugShowCheckedModeBanner: false,
    );
  }
}

const double _tabIconSize = 25;
const double _tabPadding = 20;

class TabMenu extends StatefulWidget {
  @override
  _TabMenuState createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> with TickerProviderStateMixin {
  Animation _anim;
  AnimationController _animCont;

  int _menuMaxCornerRadius = 45;
  double _frameRadius = 20;
  double _animHaltValue = 0.3;

  bool _isDragStarted = false;

  List<MapEntry<String, IconData>> _dataList;

  bool _isAnimCompleted = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    _dataList = [
      MapEntry("Advocates", Icons.account_circle),
      MapEntry("Website", Icons.tv),
      MapEntry("Community", Icons.group),
      MapEntry("Tutorials", Icons.event_note)
    ];

    _animCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _anim = Tween(begin: 320.0, end: 0.0).animate(_animCont);

    _animCont.addListener(() {
      if (_animCont.value.toStringAsFixed(1) == _animHaltValue.toString() &&
          _animCont.status == AnimationStatus.forward) _animCont.stop();
    });

    _animCont.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _isAnimCompleted = true;
      else if (status == AnimationStatus.dismissed) _isAnimCompleted = false;
    });
  }

  @override
  void dispose() {
    _animCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.all(Radius.circular(_frameRadius))),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(0, _anim.value),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(_getRadius()),
                            topRight: Radius.circular(_getRadius())),
                        color: Colors.white,
                      ),
                      height: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onVerticalDragStart: (_) {
                              _isDragStarted = true;
                            },
                            onVerticalDragUpdate: (drag) {
                              if (_isDragStarted && !_animCont.isAnimating) {
                                _isDragStarted = false;
                                if (drag.delta.dy < 0) {
                                  if (!_animCont.isCompleted)
                                    _animCont.forward(
                                        from: _animCont.value >
                                                _animHaltValue - 0.1
                                            ? _animHaltValue + 0.1
                                            : 0.0);
                                } else
                                  _animCont.reverse();
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                child: Container(
                                  height: 5,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0x443366ff),
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(15, 15))),
                                      child: FlutterLogo(),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Flutter",
                                            style: _textStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "Google",
                                            style: _textStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(10),
                                  itemBuilder: (_, pos) {
                                    return Row(
                                      children: <Widget>[
                                        Icon(
                                          _dataList[pos].value,
                                          color: Colors.black26,
                                          size: 30,
                                        ),
                                        SizedBox(width: 25),
                                        Text(
                                          _dataList[pos].key,
                                          style: _textStyle(),
                                        )
                                      ],
                                    );
                                  },
                                  separatorBuilder: (_, __) {
                                    return SizedBox(
                                      height: 20,
                                    );
                                  },
                                  itemCount: _dataList.length,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: _tabPadding + _tabIconSize,
                    color: Colors.black,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(_frameRadius),
                          bottomRight: Radius.circular(_frameRadius)),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(bottom: _tabPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CustomIcon(
                          Icons.business_center,
                          color: Colors.blueAccent,
                        ),
                        CustomIcon(
                          Icons.search,
                        ),
                        CustomIcon(
                          Icons.notifications,
                        ),
                        CustomIcon(
                          Icons.assignment_turned_in,
                        ),
                        CustomIcon(
                          Icons.message,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double _getRadius() {
    if (_animCont.status == AnimationStatus.forward) {
      if (_animCont.value <= _animHaltValue)
        return _animCont.value * _menuMaxCornerRadius / _animHaltValue;
      else
        return _menuMaxCornerRadius *
            (1 -
                (_animCont.value - _animHaltValue + 0.1) *
                    5 /
                    (10 - (_animHaltValue * 10 + 1)));
    } else
      return _menuMaxCornerRadius /
          (_isAnimCompleted ? 2 : _animHaltValue) *
          _animCont.value;
  }

  TextStyle _textStyle(
      {fontSize = 20.0, fontWeight = FontWeight.w400, color = Colors.black54}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: fontWeight, color: color, height: 1);
  }
}

class CustomIcon extends StatelessWidget {
  final IconData _icon;
  final Color color;

  CustomIcon(this._icon, {this.color = Colors.black26});

  @override
  Widget build(BuildContext context) {
    return Icon(
      _icon,
      size: _tabIconSize,
      color: color,
    );
  }
}
