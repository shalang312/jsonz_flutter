import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/details_info.dart';
import 'package:jsonz_flutter/pages/details_page/details_top_area.dart';

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
            return Container(
              child: Column(
                children: <Widget>[
                  DetailsTopArea(),
                ],
              ),
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
