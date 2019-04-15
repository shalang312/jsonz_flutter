import 'package:flutter/material.dart';
import 'package:jsonz_flutter/service/service_method.dart';
import 'dart:convert';
import 'package:jsonz_flutter/model/category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    _gateCategory();
    return Container(
      child: Center(
        child: Text('分类页面'),
      ),
    );
  }

  // 调试后台接口
  void _gateCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      print('分类页面数据...........' + data.toString());
      CategoryBigListModel list = CategoryBigListModel.formJson(data['data']);
//      CategoryModel list = CategoryModel.fromJson(data['data']);
      list.data.forEach((item) => print(item.mallCategoryName));
    });
  }
}
