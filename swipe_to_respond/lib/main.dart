import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swipe_to_respond/swipe_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SwipeToRespond(),
    );
  }
}

class SwipeToRespond extends StatefulWidget {
  @override
  _SwipeToRespondState createState() => _SwipeToRespondState();
}

class _SwipeToRespondState extends State<SwipeToRespond> {
  List _dataList = List();

  @override
  void initState() {
    super.initState();

    for (int pos = 0; pos < 10; pos++) _dataList.add("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (_, pos) {
                return SwipeToRespondWidget((response) {
                  _dataList.removeAt(pos);
                });
              }),
        ));
  }
}
