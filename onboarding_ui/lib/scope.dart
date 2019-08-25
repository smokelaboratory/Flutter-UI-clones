import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:scoped_model/scoped_model.dart';

class Scope extends Model {
  Animation _slideAnim;
  Color _bgColor;

  Color get bgColor => _bgColor;

  set bgColor(Color value) {
    _bgColor = value;
  }

  Animation get slideAnim => _slideAnim;

  set slideAnim(Animation value) {
    _slideAnim = value;
  }

  void changeSlideState(Animation _changedSlideAnim) {
    _slideAnim = _changedSlideAnim;
    notifyListeners();
  }

  void changeBgColor(Color newBgColor) {
    _bgColor = newBgColor;
    notifyListeners();
  }
}
