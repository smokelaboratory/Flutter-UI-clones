import 'package:flutter/material.dart';

class Loader4 extends StatefulWidget {
  @override
  _Loader4State createState() => _Loader4State();
}

class _Loader4State extends State<Loader4> with TickerProviderStateMixin {
  Animation<double> _sizeAnim, _translate1Anim, _translate2Anim;
  AnimationController _animCont;

  @override
  void initState() {
    super.initState();

    _animCont = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2300));

    _sizeAnim = Tween(begin: 50.0, end: 25.0)
        .animate(CurvedAnimation(parent: _animCont, curve: Interval(0.2, 0.9)));
    AnimationController(vsync: this, duration: Duration(seconds: 2));

    _translate1Anim = Tween(begin: 0.0, end: 25.0).animate(CurvedAnimation(
        parent: _animCont,
        curve: Interval(0.2, 0.45, curve: Curves.easeInOutBack)));
    AnimationController(vsync: this, duration: Duration(seconds: 2));
    
    _translate2Anim = Tween(begin: 0.0, end: 50.0).animate(CurvedAnimation(
        parent: _animCont,
        curve: Interval(0.55, 0.9, curve: Curves.easeInOutBack)));

    _animCont.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animCont.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedBuilder(
      animation: _sizeAnim,
      builder: (_, __) {
        return SizedBox(
          height: _sizeAnim.value,
          width: _sizeAnim.value,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(-_translate1Anim.value, 0.0),
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  _getCircle(),
                  Transform.translate(
                    offset: Offset(-_translate2Anim.value, 0.0),
                    child: _getCircle(),
                  ),
                ]),
              ),
              Transform.translate(
                offset: Offset(_translate1Anim.value, 0.0),
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  _getCircle(),
                  Transform.translate(
                    offset: Offset(_translate2Anim.value, 0.0),
                    child: _getCircle(),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    ));
  }

  Container _getCircle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown,
        shape: BoxShape.circle,
      ),
    );
  }
}
