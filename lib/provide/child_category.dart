import 'package:flutter/material.dart';
import '../model/category.dart';

//ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  // 子类被点击的索引
  int childIndex = 0;
  // 大类的categoryId
  String categoryId = '4';

  getChildCategory(List<BxMallSubDto> list, String id) {
    // 点击大类切换，子类索引需要清零
    childIndex = 0;
    categoryId = id;
    BxMallSubDto all = new BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    // 先加入对象
    childCategoryList = [all];
    childCategoryList.addAll(list);
//    childCategoryList = list;
    notifyListeners();
  }

  // 改变二级列表的索引
  changeChildIndex(index) {
    childIndex = index;
    notifyListeners();
  }

}
