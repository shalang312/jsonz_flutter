import 'package:flutter/material.dart';
import '../model/category.dart';

//ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  // 子类被点击的索引
  int childIndex = 0;
  // 大类的categoryId
  String categoryId = '4';
  String subId =''; //小类ID
  // 点击改变大类时，需要将页面改为1
  int page = 1;
  // 上拉加载更多的提示语
  String noMoreText = "";

  getChildCategory(List<BxMallSubDto> list, String id) {
    // 点击大类切换，子类索引需要清零
    childIndex = 0;
    categoryId = id;
    subId=''; //点击大类时，把子类ID清空
    page = 1;
    noMoreText = "";
    BxMallSubDto all = new BxMallSubDto();
    all.mallSubId = '';
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
  changeChildIndex(int index, String id) {
    childIndex = index;
    subId=id;
    page = 1;
    noMoreText = "";
    notifyListeners();
  }

  // 增加page的方法
  addPage() {
    page++;
  }

  // 改变noMoreText数据
  changeNoMore(String text) {
    noMoreText = text;
  }

}
