import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:jsonz_flutter/provide/counter.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Number(),
            MyButton(),
          ],
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200),
      // 使用Provide Widget的形式就可以获取状态，比如现在获取数字的状态
      child: Provide<Counter>(
        /*
        每次通知数据刷新时，builder将会重新构建这个小部件。
        builder方法接收三个参数，这里主要介绍第二个和第三个。
        第二个参数child：假如这个小部件足够复杂，内部有一些小部件是不会改变的，
          那么我们可以将这部分小部件写在Provide的child属性中，让builder不再重复创建这些小部件，以提升性能。
        第三个参数counter：这个参数代表了我们获取的顶层providers中的状态。
        scope：通过指定ProviderScope获取该键所对应的状态。在需要使用多个相同类型状态的时候使用。
         */
        builder: (context, child, counter) {
          return Text(
            '${counter.value}',
            style: Theme.of(context).textTheme.display1, // 系统自带的style
          );
        },
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          Provide.value<Counter>(context).increment();
        },
        child: Text('递增'),
      ),
    );
  }
}
