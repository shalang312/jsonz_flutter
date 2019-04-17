import 'package:flutter/material.dart';

// Provide状态管理实例
/*
这里混入了ChangeNotifier，意思是可以不用管理听众。现在你可以看到数和操作数据的方法都在Provide中，
很清晰的把业务分离出来了。通过notifyListeners可以通知听众刷新。
 */
class Counter with ChangeNotifier {
  int value = 0;
  increment() {
    value++;
    // 通知听众数据改变
    notifyListeners();
  }
}
