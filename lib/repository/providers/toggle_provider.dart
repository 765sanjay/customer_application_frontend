import 'package:flutter/material.dart';

class ToggleProvider extends ChangeNotifier {
  bool isSklyFlashSelected = true;

  void toggle(bool value) {
    isSklyFlashSelected = value;
    notifyListeners();
  }
} 