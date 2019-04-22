import 'package:flutter/material.dart';
import 'package:jsonz_flutter/service/service_method.dart';
import 'dart:convert';
import 'package:jsonz_flutter/model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/child_category.dart';
import 'package:jsonz_flutter/model/categoryGoodsList.dart';
import 'package:jsonz_flutter/provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                CategoryGoodsList(),
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
    _getGoodsList();
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
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  // 获取商品列表数据
  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': "",
      'page': 1
    };
    await request("getMallGoods", formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
//      print('===============>:${goodsList.data[0].goodsName}');
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data);

//      setState(() {
//        list = goodsList.data;
//      });
//      print("分类商品列表===============>:${data}");
    });
  }

  // 左侧大类的点击
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
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(100),
//        padding: EdgeInsets.only(left: 10),
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

// 二级导航
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
                return _rightInkWell(
                    index, childCategory.childCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  // 二级子类标题点击
  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isCheck = false;
    // 第二种获取状态的方式
    isCheck = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        // 改变子类标题索引状态
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getSubGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              // (显示高亮效果)
              color: isCheck ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  // 获取子类条目的分类数据
  void _getSubGoodsList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request("getMallGoods", formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
//      print('===============>:${goodsList.data[0].goodsName}');
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(goodsList.data);
      }

//      setState(() {
//        list = goodsList.data;
//      });
//      print("分类商品列表===============>:${data}");
    });
  }
}

// 商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
//  List list = [];

//  @override
//  void initState() {
//    _getGoodsList();
//    super.initState();
//  }

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  // 控制器,可以设置列表的位置
  var scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            // 列表位置，放到最上边
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化：${e}');
        }
        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              /*
            The height of the toolbar component of the [AppBar].
            const double kToolbarHeight = 56.0;
            The height of the bottom navigation bar.
            const double kBottomNavigationBarHeight = 56.0;
            The height of a tab bar containing text.
            const double kTextTabBarHeight = 48.0;
       */
//          height: ScreenUtil.screenHeightDp - 80 - 56 - 48,
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  moreInfo: '加载中。。。',
                  loadReadyText: '上拉加载',
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listWidget(data.goodsList, index);
                  },
                ),
                loadMore: () async {
                  _getMoreList();
//                  print('没有更多了......');
                },
              ),
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  // 上拉加载更多
  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);

      if (goodsList.data == null) {
        print('加载更多数据时没有数据了==============================》');
        Fluttertoast.showToast(
          msg: "已经到底了",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
//          timeInSecForIos: 1,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0,
        );
//        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getMoreGoodsList(goodsList.data);
      }
    });
  }

//  void _getGoodsList() async {
//    var data = {'categoryId': '4', 'categorySubId': "", 'page': 1};
//    await request("getMallGoods", formData: data).then((val) {
//      var data = json.decode(val.toString());
//      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
//      print('===============>:${goodsList.data[0].goodsName}');
//      setState(() {
//        list = goodsList.data;
//
//      });
////      print("分类商品列表===============>:${data}");
//    });
//  }

  // 商品图片
  Widget _goodsImage(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(180),
      child: Image.network(newList[index].image),
    );
  }

  // 商品名称
  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(List newList, int index) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 10),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  // 控件组合
  Widget _listWidget(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
