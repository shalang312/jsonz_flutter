import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:jsonz_flutter/model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  List<CartInfoMode> cartList = [];

  save(goodsId, goodsName, count, price, images) async {
    //初始化SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo'); // 获取持久化保存的数据
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    //声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; // 默认为没有
    int iIndex = 0; // 进行循环的索引
    // item 相当于购物车列表中的每一栏条目
    tempList.forEach((item) {
      // 如果存在，数量进行+1操作
      if (item['goodsId'] == goodsId) {
        tempList[iIndex]['count'] = item['count'] + 1;
        cartList[iIndex].count++;
        isHave = true;
      }
      iIndex++;
    });
    // 如果没有，进行增加
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
      };
      tempList.add(newGoods);
      cartList.add(CartInfoMode.fromJson(newGoods));
//      tempList.add({
//        'goodsId': goodsId,
//        'goodsName': goodsName,
//        'count': count,
//        'price': price,
//        'images': images,
//      });
    }
    // 由于tempList是集合，所以需要转换成String保存
    cartString = json.encode(tempList).toString();
    print('字符串>>>>>>>>>>>>>>>>>${cartString}');
    print('数据模型>>>>>>>>>>>>>>>${cartList}');
    prefs.setString('cartInfo', cartString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();//清空键值对
    prefs.remove('cartInfo');
    cartList = [];
    print('清空完成-----------------');
    // 有交互时才会设置
    notifyListeners();
  }

  // 得到购物车中的商品
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //获得购物车中的商品,这时候是一个字符串
    cartString = prefs.getString('cartInfo');
    //把cartList进行初始化，防止数据混乱
    cartList = [];
    //判断得到的字符串是否有值，如果不判断会报错
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      tempList.forEach((item) {
        cartList.add(CartInfoMode.fromJson(item));
      });
    }
    notifyListeners();
  }
}
