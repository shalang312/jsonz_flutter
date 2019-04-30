import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jsonz_flutter/model/cartInfo.dart';

class CartInfo extends StatelessWidget {
  CartInfoMode item;

  CartInfo(this.item);

  @override
  Widget build(BuildContext context) {
    print(item);
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          width: 1,
          color: Colors.black12,
        )),
      ),
      child: Row(
        children: <Widget>[
          _cartCheckBt(item),
          _cartImage(item),
          _cartGoodsName(item),
          _cartPrice(item),
        ],
      ),
    );
  }

  // 多选按钮
  Widget _cartCheckBt(CartInfoMode item) {
    return Container(
      child: Checkbox(
        // 选中状态
        value: true,
        onChanged: (bool val) {}, // 点击变换
        // 选中时颜色变换
        activeColor: Colors.pink,
      ),
    );
  }

  // 商品图片
  Widget _cartImage(CartInfoMode item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black12,
      )),
      child: Image.network(item.images),
    );
  }

  // 商品名称
  Widget _cartGoodsName(CartInfoMode item) {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(item.goodsName),
        ],
      ),
    );
  }

  // 商品价格
  Widget _cartPrice(CartInfoMode item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥${item.price}'),
          Container(
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.delete_forever,
                color: Colors.black26,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
