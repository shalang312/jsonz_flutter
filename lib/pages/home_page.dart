import 'package:flutter/material.dart';
import 'package:jsonz_flutter/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据';

  // 有了banner之后，就不需要初始化状态了
//  @override
//  void initState() {
//    getHomePageContent().then((val) {
//      setState(() {
//        homePageContent = val.toString();
//      });
//    });
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
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
          future: getHomePageContent(), // 异步方法
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              print("data============>" + data.toString());
              // 后台数据处理
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              return Column(
                children: <Widget>[
                  SwiperDiy(
                    swipDataList: swiper,
                  ),
                  TopNavigator(
                    navigatorList: navigatorList,
                  ),
                ],
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
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swipDataList;

  // 接收数据
  SwiperDiy({this.swipDataList});

  @override
  Widget build(BuildContext context) {
    // 设备的像素密度
    print("设备的像素密度:${ScreenUtil.pixelRatio}");
    print("设备的高:${ScreenUtil.screenHeight}");
    print("设备的宽:${ScreenUtil.screenWidth}");
    return Container(
      height: ScreenUtil().setHeight(333),
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
