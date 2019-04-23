// 把Fluro的Router静态化
import 'package:fluro/fluro.dart';

class Application {
  // 这一步就是为了使用方便，直接把Router进行静态化，这样在任何一个页面都可以直接进行使用了
  static Router router;
}
