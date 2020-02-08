import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_loaders/loader_1.dart';
import 'package:progress_loaders/loader_3.dart';
import 'package:progress_loaders/loader_2.dart';
import 'package:progress_loaders/loader_4.dart';

void main() => runApp(MaterialApp(
      home: Screen1(),
      debugShowCheckedModeBanner: false,
    ));

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Loader3(),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.lightGreenAccent,
                child: Loader4(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
