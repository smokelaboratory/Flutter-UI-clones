import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BalloonSlider(),
    );
  }
}

double sliderCurrentPos = 0.0;
Color sliderThemeColor = Colors.purple;

class BalloonSlider extends StatefulWidget {
  @override
  _BalloonSliderState createState() => _BalloonSliderState();
}

class _BalloonSliderState extends State<BalloonSlider>
    with TickerProviderStateMixin {
  AnimationController animationController, scaleAnimationController;
  Animation<double> animation, scaleAnimation, thumbAnimation;

  double currentSlideValue = 0, prevSliderValue = 0;

  SlideDirection direction;

  double balloonWidth = 50;
  Offset balloonFlyTranslationFactor = Offset(90, 5);

  @override
  void initState() {
    super.initState();

    var animationDuration = Duration(milliseconds: 300);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
    scaleAnimationController =
        AnimationController(vsync: this, duration: animationDuration);

    animation = Tween<double>(begin: 0, end: 35 * math.pi / 180)
        .animate(animationController);
    scaleAnimation =
        Tween<double>(begin: 0, end: 1).animate(scaleAnimationController);
    thumbAnimation =
        Tween<double>(begin: 2, end: 1).animate(scaleAnimationController);

    scaleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        animationController.forward(from: animationController.value);
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed)
        scaleAnimationController.reverse(from: scaleAnimationController.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.arrow_back_ios),
              SizedBox(
                height: 50,
              ),
              Text(
                """Choose
balloon
quantity""",
                style: getTextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: animation,
                      builder: (_, __) {
                        return SizedBox(
                          width: balloonWidth,
                          child: Transform.translate(
                            offset: Offset(
                                (direction == SlideDirection.LEFT
                                        ? -animation.value
                                        : animation.value) *
                                    balloonFlyTranslationFactor.dx,
                                animation.value *
                                    balloonFlyTranslationFactor.dy),
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  sliderCurrentPos - balloonWidth / 1.2, 0, 0),
                              child: Transform.rotate(
                                angle: direction == SlideDirection.LEFT
                                    ? -animation.value
                                    : animation.value,
                                child: AnimatedBuilder(
                                  animation: scaleAnimation,
                                  builder: (_, __) {
                                    return Transform.scale(
                                      alignment: Alignment.bottomCenter,
                                      scale: scaleAnimation.value,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            "images/ic_balloon.png",
                                            color: sliderThemeColor,
                                          ),
                                          Text(
                                            currentSlideValue
                                                .toInt()
                                                .toString(),
                                            style: getTextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: thumbAnimation,
                      builder: (_, __) {
                        return SliderTheme(
                            data: SliderThemeData(
                                thumbShape: CustomSliderThumb(
                                  thumbRadius: 15 / thumbAnimation.value +
                                      thumbAnimation.value,
                                  strokeWidth:
                                      math.pow(thumbAnimation.value, 3),
                                ),
                                overlayColor: Colors.transparent,
                                activeTrackColor: sliderThemeColor,
                                inactiveTrackColor: Color(0xff10000000),
                                trackHeight: 2),
                            child: Slider(
                              value: currentSlideValue,
                              onChanged: (value) {
                                setState(() {
                                  currentSlideValue = value;

                                  if (prevSliderValue < currentSlideValue)
                                    direction = SlideDirection.LEFT;
                                  else if (prevSliderValue > currentSlideValue)
                                    direction = SlideDirection.RIGHT;

                                  prevSliderValue = value;
                                });
                              },
                              max: 100,
                              min: 0,
                              onChangeEnd: (value) {

                                animationController.reverse(
                                    from: animationController.value);
                              },
                              onChangeStart: (value) {
                                scaleAnimationController.forward(
                                    from: scaleAnimationController.value);
                              },
                            ));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  color: Color(0xfff8bd47),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Next",
                          style: getTextStyle(),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle getTextStyle({Color color = Colors.black, double fontSize = 14}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: "Cabin",
        fontWeight: FontWeight.w700,
        height: 0.75);
  }
}

class CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius, strokeWidth;

  const CustomSliderThumb({this.thumbRadius, this.strokeWidth});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    var thumbRect = Rect.fromCircle(center: center, radius: thumbRadius);

    sliderCurrentPos = center.dx;

    var thumbRRect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(thumbRect.left, thumbRect.top),
        Offset(thumbRect.right, thumbRect.bottom),
      ),
      Radius.circular(thumbRadius),
    );

    var canvas = context.canvas;
    canvas.drawRRect(
        thumbRRect,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    canvas.drawRRect(
        thumbRRect,
        Paint()
          ..color = sliderThemeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke);
  }
}

enum SlideDirection { LEFT, RIGHT }
