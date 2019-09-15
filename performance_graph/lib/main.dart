import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerformanceGraph(),
    );
  }
}

class PerformanceGraph extends StatefulWidget {
  @override
  _PerformanceGraphState createState() => _PerformanceGraphState();
}

class _PerformanceGraphState extends State<PerformanceGraph>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  Map<String, double> _ratingData = {
    "Batting": 84,
    "Confidence": 75,
    "Fielding": 70,
    "Catching": 80,
    "Bowling": 55,
    "Stamina": 65
  };

  double _graphSize = 170;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _animation =
        Tween<double>(begin: 0, end: 100.0).animate(_animationController);

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: _graphSize,
                    width: _graphSize,
                    child: CustomPaint(
                      painter: GraphGrid(),
                    ),
                  ),
                  Container(
                    height: _graphSize,
                    width: _graphSize,
                    child: CustomPaint(
                      painter: GraphRating(
                          ratingData: _ratingData,
                          color: Color(0xee336699),
                          animationValue: _animation.value),
                    ),
                  ),
                  Container(
                    height: _graphSize + 80,
                    width: _graphSize + 80,
                    child: CustomPaint(
                      painter: GraphText(
                          ratingData: _ratingData,
                          animationValue: _animation.value),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _animationController.forward(from: 0.0);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Player analysis",
                        style: TextStyle(
                            fontFamily: "Khula",
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class GraphGrid extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var divisions = 5;

    var gap = size.height / divisions;

    for (int pos = 0; pos < divisions; pos++) {
      var height = size.height - pos * gap;
      var width = size.width - pos * gap;
      var translateFactor =
          pos * gap / 2; //to translate a polygon in diagonal direction

      canvas.drawPath(
          Path()
            ..addPolygon([
              Offset(width / 2, 0).translate(translateFactor, translateFactor),
              Offset(width, height / 4)
                  .translate(translateFactor, translateFactor),
              Offset(width, height * 3 / 4)
                  .translate(translateFactor, translateFactor),
              Offset(width / 2, height)
                  .translate(translateFactor, translateFactor),
              Offset(0, height * 3 / 4)
                  .translate(translateFactor, translateFactor),
              Offset(0, height / 4).translate(translateFactor, translateFactor),
            ], true),
          Paint()
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke
            ..color = Colors.white54);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class GraphRating extends CustomPainter {
  List<double> ratings;
  Color color;
  double animationValue;

  Size _size;

  GraphRating(
      {Map<String, double> ratingData, this.color, this.animationValue}) {
    ratings = ratingData.values.toList();
  }

  @override
  void paint(Canvas canvas, Size size) {
    this._size = size;

    canvas.drawPath(
        Path()
          ..addPolygon([
            Offset(
                size.width / 2,
                _getY(
                    maxY: 0, rating: ratings[0], isPositiveFromCenter: false)),
            Offset(
                _getX(
                    maxX: size.width,
                    rating: ratings[1],
                    isPositiveFromCenter: true),
                _getY(
                    maxY: size.height / 4,
                    rating: ratings[1],
                    isPositiveFromCenter: false)),
            Offset(
                _getX(
                    maxX: size.width,
                    rating: ratings[2],
                    isPositiveFromCenter: true),
                _getY(
                    maxY: size.height * 3 / 4,
                    rating: ratings[2],
                    isPositiveFromCenter: true)),
            Offset(
                size.width / 2,
                _getY(
                    maxY: size.height,
                    rating: ratings[3],
                    isPositiveFromCenter: true)),
            Offset(
                _getX(maxX: 0, rating: ratings[4], isPositiveFromCenter: false),
                _getY(
                    maxY: size.height * 3 / 4,
                    rating: ratings[4],
                    isPositiveFromCenter: true)),
            Offset(
                _getX(maxX: 0, rating: ratings[5], isPositiveFromCenter: false),
                _getY(
                    maxY: size.height / 4,
                    rating: ratings[5],
                    isPositiveFromCenter: false)),
          ], true),
        Paint()
          ..style = PaintingStyle.fill
          ..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double _getY({double rating, double maxY, bool isPositiveFromCenter}) {
    var originY = _size.height / 2;

    var steps = (maxY - originY).abs() / 100 * min(rating, animationValue);
    return originY + (isPositiveFromCenter ? steps : -steps);
  }

  double _getX({double rating, double maxX, bool isPositiveFromCenter}) {
    var originX = _size.width / 2;

    var steps = (maxX - originX).abs() / 100 * min(rating, animationValue);
    return originX + (isPositiveFromCenter ? steps : -steps);
  }
}

class GraphText extends CustomPainter {
  List<String> subjects;
  List<double> ratings;
  double animationValue;

  Size size;

  GraphText({Map<String, double> ratingData, this.animationValue}) {
    ratings = ratingData.values.toList();
    subjects = ratingData.keys.toList();
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;

    var subject1 = _getTextPainter(
        rating: ratings[0], subject: subjects[0], isGravityCenter: true);
    subject1.paint(canvas, Offset(size.width / 2 - subject1.width / 2, 0));

    var subject2 = _getTextPainter(rating: ratings[1], subject: subjects[1]);
    subject2.paint(canvas, Offset(size.width - 30, size.height / 4));

    var subject3 = _getTextPainter(rating: ratings[2], subject: subjects[2]);
    subject3.paint(
        canvas, Offset(size.width - 30, size.height * 3 / 4 - subject3.height));

    var subject4 = _getTextPainter(
        rating: ratings[3], subject: subjects[3], isGravityCenter: true);
    subject4.paint(
        canvas,
        Offset(size.width / 2 - subject4.width / 2,
            size.height - subject4.height));

    var subject5 = _getTextPainter(
        rating: ratings[4],
        subject: subjects[4],
        textDirection: TextDirection.rtl);
    subject5.paint(
        canvas, Offset(0 - 20.0, size.height * 3 / 4 - subject5.height));

    var subject6 = _getTextPainter(
        rating: ratings[5],
        subject: subjects[5],
        textDirection: TextDirection.rtl);
    subject6.paint(canvas, Offset(0 - 20.0, size.height / 4));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  TextPainter _getTextPainter(
      {String subject,
      double rating,
      TextDirection textDirection = TextDirection.ltr,
      bool isGravityCenter = false}) {
    return TextPainter(
        text: TextSpan(children: [
          TextSpan(
              text: "${min(animationValue, rating).toInt()}\n",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: "Khula")),
          TextSpan(
              text: subject,
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontFamily: "Khula",
                  height: 0.4))
        ]),
        textDirection: textDirection,
        textAlign: isGravityCenter ? TextAlign.center : TextAlign.start)
      ..layout(minWidth: 0, maxWidth: size.width);
  }
}
