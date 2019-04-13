import 'package:flutter/material.dart';
import 'package:jsonz_flutter/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/*
AutomaticKeepAliveClientMixin这个Mixin就是Flutter为了保持页面设置的。
  哪个页面需要保持页面状态，就在这个页面进行混入。
不过使用使用这个Mixin是有几个先决条件的：
  1.使用的页面必须是StatefulWidget,如果是StatelessWidget是没办法办法使用的。
  2.其实只有两个前置组件才能保持页面状态：PageView和IndexedStack。
  3.重写wantKeepAlive方法，如果不重写也是实现不了的。
 */
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';
  int page = 1;
  List<Map> hotGoodsList = [];

  // 有了banner之后，就不需要初始化状态了
  @override
  void initState() {
//    getHomePageContent().then((val) {
//      setState(() {
//        homePageContent = val.toString();
//      });
//    });
    super.initState();
    _getHotGoods();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("百信生活+"),
        ),

//        body: SingleChildScrollView(
//          child: Text(
//            homePageContent
//          ),
//        ),
        body: FutureBuilder(
//          future: getHomePageContent(), // 异步方法
          future: request('homePageContent', formData: formData), // 异步方法
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              print("data============>" + data.toString());
              // 后台数据处理
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              // 广告图片的数据
              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              // 店长电话模块数据
              String leaderImage =
                  data['data']['shopInfo']['leaderImage']; //店长图片
              String leaderPhone =
                  data['data']['shopInfo']['leaderPhone']; //店长电话
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();
              String floor1Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
              String floor2Title =
                  data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层2的标题图片
              String floor3Title =
                  data['data']['floor3Pic']['PICTURE_ADDRESS']; //楼层3的标题图片
              List<Map> floor1 =
                  (data['data']['floor1'] as List).cast(); //楼层1商品和图片
              List<Map> floor2 =
                  (data['data']['floor2'] as List).cast(); //楼层2商品和图片
              List<Map> floor3 =
                  (data['data']['floor3'] as List).cast(); //楼层3商品和图片
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SwiperDiy(
                      swipDataList: swiper,
                    ),
                    TopNavigator(
                      navigatorList: navigatorList,
                    ),
                    AdbBanner(adPicture: adPicture),
                    LeaderPhone(leaderImage, leaderPhone),
                    Recommend(recommendList),
                    FloorTitle(floor1Title),
                    FloorContent(floor1),
                    FloorTitle(floor2Title),
                    FloorContent(floor2),
                    FloorTitle(floor3Title),
                    FloorContent(floor3),
                    _hotGoods(),
//                    HotGoods(),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          },
        ),
      ),
    );
  }

  // 获取热销商品数据
  void _getHotGoods() {
    var formData = {'page': page};
    request("homePageBelowContent", formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoods = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoods);
        page++;
      });
    });
  }

  // 变量形式的控件
  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
//    decoration: BoxDecoration(
//        color: Colors.white,
//        border: Border(
//            bottom: BorderSide(
//          width: 5,
//          color: Colors.black12,
//        ))),
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  // 方法形式的控件
  // 火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      // 将后台获取到的List<Map>数据转换成List<Widget>格式，
      // 便于直接放在瀑布流布局中使用
      List<Widget> widgetList = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {},
          child: Container(
//            width: ScreenUtil().setWidth(245),
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  val['image'],
//                  width: ScreenUtil().setWidth(238),
                  width: ScreenUtil().setWidth(370),
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();

      // 流式布局
      return Wrap(
//        spacing: 3,
        spacing: 2,
        children: widgetList,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
      );
    } else {
      return Text('');
    }
  }

  // 将列表和标题组合
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swipDataList;

  // 接收数据
  SwiperDiy({this.swipDataList});

  @override
  Widget build(BuildContext context) {
    // 设备的像素密度
//    print("设备的像素密度:${ScreenUtil.pixelRatio}");
//    print("设备的高:${ScreenUtil.screenHeight}");
//    print("设备的宽:${ScreenUtil.screenWidth}");
    return Container(
      height: ScreenUtil().setHeight(330),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swipDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        itemCount: 3,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 首页导航区域
class TopNavigator extends StatelessWidget {
  final List navigatorList;

//  TopNavigator(this.navigatorList);
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridviewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 截取掉多余的数据
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }

    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        // 每行数量，会自动根据返回的数据计算多少行
        crossAxisCount: 5,
        padding: EdgeInsets.all(5),
        children: navigatorList.map((item) {
          return _gridviewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 展示广告的区域
class AdbBanner extends StatelessWidget {
  final String adPicture;

//  AdbBanner(this.adPicture);
  AdbBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 点击图片，进行拨打电话(店长电话模块)
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话

  LeaderPhone(this.leaderImage, this.leaderPhone);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _lauchUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  // 拨打电话的方法
  void _lauchUrl() async {
    String url = "tel:" + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend(this.recommendList);

  // 标题栏方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          width: 0.5,
          color: Colors.black12,
        )),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 横向列表方法
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(350),
//      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
          // listview方向属性
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          // 构造器传值，固定写法
          itemBuilder: (context, index) {
            return _item(index);
          }),
    );
  }

  // 商品单独项方法
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(410),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  // 图片地址
  final String picture_address;

  FloorTitle(this.picture_address);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent(this.floorGoodsList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

// 火爆专区数据
class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    super.initState();
//    getHomePageBeloContent().then((val) {
//      print(val);
//    });
    request("homePageBelowContent", formData: 1).then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('js'),
    );
  }

  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  Widget _wrapList() {}
}
