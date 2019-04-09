import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();
  String showText = '欢迎来到';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("没好人间"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: '类型',
                    helperText: '请输入类型',
                  ),
                  // 默认会打开软键盘
                  autofocus: false,
                ),
                RaisedButton(
                  onPressed: _chooseAction,
                  child: Text('完毕'),
                ),
                Text(
                  showText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _chooseAction() {
    print("开始选择");
    if (typeController.text.toString() == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('不能为空'),
            ),
      );
    } else {
      getHttp(typeController.text.toString()).then((val) {
        setState(() {
          /*
      {"success":true,"data":{"default":"jspang","_req":{"method":"GET","url":"/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=123456",
      "header":{"host":"www.easy-mock.com","x-forwarded-for":"116.226.251.94","x-forwarded-proto":"https","connection":"close",
      "content-length":"0","user-agent":"Dart/2.1 (dart:io)","accept-encoding":"gzip"}},"name":"123456走进了房间，来为你亲情服务"}}
       */
          showText = val['data']['name'].toString();
        });
      });
    }
  }

  Future getHttp(String typeText) async {
    try {
      Response response;
      var data = {'name': typeText};
      response = await Dio().get(
        'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian',
        queryParameters: data,
      );
      print(response);
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}

//class HomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    getHttp();
//    return Scaffold(
//      body: Center(
//        child: Text("商城首页"),
//      ),
//    );
//  }
//
//  // 请求服务(异步)
//  void getHttp() async {
//    try {
//      Response response;
//      var data = {'name': '123456'};
//      response = await Dio().get(
//        "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=",
//        queryParameters: data,
//      );
//      return print(response);
//    } catch (e) {
//      return print(e);
//    }
//  }
//}
