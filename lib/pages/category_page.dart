import 'package:flutter/material.dart';
import 'package:jsonz_flutter/service/service_method.dart';
import 'dart:convert';
import 'package:jsonz_flutter/model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/child_category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
//    _gateCategory();
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
              ],
            ),
          ],
        ),
      ),
    );
  }

// 调试后台接口
//  void _gateCategory() async {
//    await request('getCategory').then((val) {
//      var data = json.decode(val.toString());
//      print('分类页面数据...........' + data.toString());
//      CategoryBigListModel list = CategoryBigListModel.formJson(data['data']);
////      CategoryModel list = CategoryModel.fromJson(data['data']);
//      list.data.forEach((item) => print(item.mallCategoryName));
//    });
//  }
}

// 左侧大类导航菜单
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0; // 索引

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1, color: Colors.black12)),
      ),
      // 动态的，可自定义
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  // 后台接口数据
  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      print('分类页面数据...........' + data.toString());
//      CategoryBigListModel list = CategoryBigListModel.formJson(data['data']);
      CategoryModel category = CategoryModel.fromJson(data);
//      list.data.forEach((item) => print(item.mallCategoryName));
      setState(() {
        list = category.data;
      });
      // 设置默认第一条数据被选中，且数据需要展示
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto);
    });
  }

  // 大类的子项
  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        // 控制高亮效果改变
        setState(() {
          listIndex = index;
        });
        // 点击左侧导航之后，数据修改，并存入提供处
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 10),
        decoration: BoxDecoration(
//          color: isClick ? Colors.black12 : Colors.white,
          color: isClick ? Color.fromRGBO(236, 236, 236, 1) : Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
//  List list = ['名酒', '宝丰', '北京二锅头','名酒', '宝丰', '北京二锅头','名酒', '宝丰', '北京二锅头'];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 获取数据
      child: Provide<ChildCategory>(
        builder: (context, child, childCategory) {
          return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black12))),
            child: ListView.builder(
              itemCount: childCategory.childCategoryList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _rightInkWell(childCategory.childCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}
