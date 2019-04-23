import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodInfo = null;

  // 从后台获取商品明细信息
  getGoodsInfo(String id) {
    var formData = {'goodId': id};
    request('getGoodDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      print('商品明细信息==========>' + responseData.toString());
      goodInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

}
