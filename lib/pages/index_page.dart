// 两种风格
import 'package:flutter/material.dart';

// 倾向于ios风格
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'member_page.dart';
import 'cart_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/currentIndex.dart';

class IndexPage extends StatelessWidget {
  // 底部栏组件集合
  final List<BottomNavigationBarItem> bottomTbas = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text("首页"),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text("分类"),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text("购物车"),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text("会员中心"),
    ),
  ];

  // 页面集合
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // 需要默认初始化一个尺寸
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Provide<CurrentIndexProvide>(
      builder: (context, child, val) {
        int currentIndex =
            Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
          backgroundColor: Color.fromARGB(244, 245, 1, 0),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTbas,
            onTap: (index) {
              Provide.value<CurrentIndexProvide>(context).changeIndex(index);
            },
          ),
          /*
      为了实现切换页面后，页面状态保持的效果
       */
          body: IndexedStack(
            index: currentIndex,
            children: tabBodies,
          ),
        );
      },
    );
  }
}

// 动态组件
//class IndexPage extends StatefulWidget {
//  @override
//  _IndexPageState createState() => _IndexPageState();
//}
//
//class _IndexPageState extends State<IndexPage> {
//  // 底部栏组件集合
//  final List<BottomNavigationBarItem> bottomTbas = [
//    BottomNavigationBarItem(
//      icon: Icon(CupertinoIcons.home),
//      title: Text("首页"),
//    ),
//    BottomNavigationBarItem(
//      icon: Icon(CupertinoIcons.search),
//      title: Text("分类"),
//    ),
//    BottomNavigationBarItem(
//      icon: Icon(CupertinoIcons.shopping_cart),
//      title: Text("购物车"),
//    ),
//    BottomNavigationBarItem(
//      icon: Icon(CupertinoIcons.profile_circled),
//      title: Text("会员中心"),
//    ),
//  ];
//
//  // 页面集合
//  final List<Widget> tabBodies = [
//    HomePage(),
//    CategoryPage(),
//    CartPage(),
//    MemberPage(),
//  ];
//
//  // 索引
//  int currentIndex = 0;
//
//  // 当前选择页面
//  var currentPage;
//
//  // 默认页面
//  @override
//  void initState() {
//    currentPage = tabBodies[currentIndex];
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // 需要默认初始化一个尺寸
//    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
//    return Scaffold(
//      backgroundColor: Color.fromARGB(244, 245, 1, 0),
//      bottomNavigationBar: BottomNavigationBar(
//        type: BottomNavigationBarType.fixed,
//        currentIndex: currentIndex,
//        items: bottomTbas,
//        onTap: (index) {
//          // 切换页面之后刷新状态
//          setState(() {
//            currentIndex = index;
//            currentPage = tabBodies[currentIndex];
//          });
//        },
//      ),
//      /*
//      为了实现切换页面后，页面状态保持的效果
//       */
//      body: IndexedStack(
//        index: currentIndex,
//        children: tabBodies,
//      ),
//    );
//  }
//}
