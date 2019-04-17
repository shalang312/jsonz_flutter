import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/counter.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Provide<Counter>(
          builder: (context, child, counter) {
            return Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.display1,// 系统自带的style
            );
          },
        ),
      ),
    );
  }
}
