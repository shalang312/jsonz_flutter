import 'package:flutter/material.dart';
import 'package:jsonz_flutter/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';

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
              List<Map> swiper = (data['data']['slides'] as List).cast();
              return Column(
                children: <Widget>[
                  SwiperDiy(
                    swipDataList: swiper,
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
    return Container(
      height: 180,
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
