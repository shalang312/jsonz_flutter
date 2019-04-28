import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/counter.dart';
import 'package:jsonz_flutter/provide/child_category.dart';
import 'package:jsonz_flutter/provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import 'package:jsonz_flutter/router/application.dart';
import 'package:jsonz_flutter/router/routers.dart';
import 'package:jsonz_flutter/provide/details_info.dart';
import 'package:jsonz_flutter/provide/cart.dart';

void main() {
  // 然后进行将provide和counter引入程序顶层。
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsList = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var providers = Providers();
  // 初始化路由
  final router = Router();
  Routers.configureRoutes(router);
  // 静态化操作
  Application.router = router;

  // ..表示返回本身对象，即链式使用
  // 泛型调用
  // 将counter对象添加进providers
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsList))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<ChildCategory>.value(childCategory)); // 多种状态管理样式
  // ProviderNode封装了InheritWidget，并且提供了 一个providers容器用于放置状态。
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        // 必须操作的固定写法
        onGenerateRoute: Application.router.generator,

        debugShowCheckedModeBanner: false, // 去除debug标记
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}
