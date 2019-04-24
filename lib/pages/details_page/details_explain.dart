import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 说明区控件
class DetailsExplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(15),
      child: Text(
        '说明：>急速送达 > 正品保证',
        style: TextStyle(
          color: Colors.red,
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
    );
  }
}
