import 'package:flutter/material.dart';

class LoadingStateProvider extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoadingComplete() {
    _isLoading = false;
    notifyListeners();
  }
}
