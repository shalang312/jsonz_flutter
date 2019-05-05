import 'package:flutter/material.dart';
import 'package:jsonz_flutter/provide/cart.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/model/cartInfo.dart';
import 'package:jsonz_flutter/pages/cart_page/cart_item.dart';
import 'package:jsonz_flutter/pages/cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          List<CartInfoMode> cartList =
              Provide.value<CartProvide>(context).cartList;
          if (snapshot.hasData && cartList != null) {
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, childCategory) {
                    cartList = Provide.value<CartProvide>(context).cartList;
                    print(cartList);
                    return Container(
                      margin: EdgeInsets.only(bottom: 50),
                      child: ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          return CartInfo(cartList[index]);
                        },
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                ),
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}

//class CartPage extends StatefulWidget {
//  @override
//  _CartPageState createState() => _CartPageState();
//}
//
//class _CartPageState extends State<CartPage> {
//  List<String> testList = [];
//
//  @override
//  Widget build(BuildContext context) {
//    _show(); // 每次进入前进行显示
//    return Container(
//      child: Column(
//        children: <Widget>[
//          Container(
//            height: 500,
//            child: ListView.builder(
//              itemCount: testList.length,
//              itemBuilder: (context, index) {
//                return ListTile(
//                  title: Text(
//                    testList[index],
//                  ),
//                );
//              },
//            ),
//          ),
//          RaisedButton(
//            onPressed: () {
//              _add();
//            },
//            child: Text('增加'),
//          ),
//          RaisedButton(
//            onPressed: () {
//              _clear();
//            },
//            child: Text('清空'),
//          ),
//        ],
//      ),
//    );
//  }
//
//  void _add() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String temp = '技术';
//    testList.add(temp);
//    prefs.setStringList('testInfo', testList);
//    _show();
//  }
//
//  void _show() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      if (prefs.getStringList('testInfo') != null) {
//        testList = prefs.getStringList('testInfo');
//      }
//    });
//  }
//
//  void _clear() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    //prefs.clear(); //全部清空
//    prefs.remove('testInfo');
//    setState(() {
//      testList = [];
//    });
//  }
//}
