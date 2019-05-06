import 'package:flutter/material.dart';

class CurrentIndexProvide with ChangeNotifier {
  int currentIndex = 0;

  // 根据新页面的标签跳转
  changeIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }
}
