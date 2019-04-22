import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';

class CategoryGoodsListProvide  with ChangeNotifier {
  List<CategoryListData> goodsList = [];

  // 点击大类，刷新更换商品列表
  getGoodsList(List<CategoryListData> list) {
    goodsList = list;
    notifyListeners();
  }
  // 上拉加载更多数据
  getMoreGoodsList(List<CategoryListData> list) {
    goodsList.addAll(list);
    notifyListeners();
  }

}
