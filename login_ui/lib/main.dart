import 'package:flutter/material.dart';

void main() => runApp(LoginUi());

class LoginUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(cursorColor: Colors.white),
    );
  }
}

double width;
double cardHeight = 350;
double verticalGap = 70;
double horizontalGap = 25;
double buttonRadius = 50;
const double margin = 20;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(margin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: width,
                  height: cardHeight + verticalGap * 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                          bottom: verticalGap + buttonRadius,
                          right: horizontalGap,
                          child: CardWidget(
                            color: 0xff17224e,
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextFieldWidget(
                                          text: "Email Address",
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextFieldWidget(
                                          text: "Password",
                                          isPassword: true,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            "Forgot Password?",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Positioned(
                        bottom: buttonRadius,
                        left: horizontalGap,
                        child: CardWidget(
                          color: 0xff16e9e1,
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFieldWidget(
                                        text: "Name",
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFieldWidget(
                                        text: "Email Address",
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFieldWidget(
                                        text: "Password",
                                        isPassword: true,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: buttonRadius * 2,
                          height: buttonRadius * 2,
                          margin: const EdgeInsets.only(right: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(buttonRadius)),
                            color: Color(0xff17224e),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.only(left: margin * 2),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "or sign in using",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconWidget(icon: "lib/assets/fb.png"),
                          SizedBox(
                            width: 22,
                          ),
                          IconWidget(icon: "lib/assets/google.png")
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  int color;
  Widget child;

  CardWidget({this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width - margin * 2 - horizontalGap,
      height: cardHeight,
      child: Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        color: Color(color),
        child: child,
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  String text;
  bool isPassword;

  TextFieldWidget({this.text, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: Colors.white),
        obscureText: isPassword,
        decoration: InputDecoration(
            suffixIcon: isPassword
                ? Icon(
                    Icons.remove_red_eye,
                    size: 20,
                    color: Colors.white,
                  )
                : null,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: text,
            hintStyle: TextStyle(color: Colors.white)));
  }
}

class IconWidget extends StatelessWidget {
  String icon;

  IconWidget({this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        width: 35,
        padding: const EdgeInsets.all(8),
        decoration:
            BoxDecoration(color: Color(0xff17224e), shape: BoxShape.circle),
        child: Image(
          image: AssetImage(icon),
          color: Colors.white,
        ));
  }
}
