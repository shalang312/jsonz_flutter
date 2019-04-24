import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/details_info.dart';
import 'package:jsonz_flutter/pages/details_page/details_top_area.dart';
import 'package:jsonz_flutter/pages/details_page/details_explain.dart';
import 'package:jsonz_flutter/pages/details_page/details_tabbar.dart';
import 'package:jsonz_flutter/pages/details_page/detals_web.dart';
import 'package:jsonz_flutter/pages/details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {
  String goodsId;

  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print('返回上一页');
            Navigator.pop(context);
          },
        ),
        title: Text('商品详情页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 层叠组件
            return Stack(
              children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      DetailsTopArea(),
                      DetailsExplain(),
                      DetailsTabBar(),
                      DetailsWeb(),
                    ],
                  ),
                ),
                // 定位作用
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailsBottom(),
                ),
              ],
            );
          } else {
            return Text("加载中...");
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
//    print('商品详情信息加载完成。。。。。。。。。。。。。');
  }
}
