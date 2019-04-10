import 'package:flutter/material.dart';
import 'package:jsonz_flutter/service/service_method.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String homePageContent = '正在获取数据';
  @override
  void initState() {
    getHomePageContent().then((val){
      setState(() {
        homePageContent = val.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("百信生活+"),
        ),
        body: SingleChildScrollView(
          child: Text(
            homePageContent
          ),
        ),
      ),
    );
  }
}


