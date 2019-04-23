import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../router/router_handler.dart';

/*
我们需要对路由有一个总体的配置，比如根目录，
出现不存在的路径如何显示，工作中我们经常把这个文件单独写一个文件
 */
class Routers {
  static String root = '/'; // 根目录
  static String detailsPage = '/detail'; // 明细页面的路径
  static void configureRoutes(Router router) {
    // 找不到路由的情况，即找不到handler的操作
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('ERROR====>ROUTE WAS NOT FONUND!!!');
    });
    // 配置路由
    router.define(detailsPage, handler: detailsHandler);
  }
}
