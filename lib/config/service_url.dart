
// 维护服务器接口文件
//const serviceUrl = 'http://test.baixingliangfan.cn/baixing';
const serviceUrl = 'http://v.jspang.com:8088/baixing/';
const servicePath = {
  // 商店首页信息,
  'homePageContent': serviceUrl + '/wxmini/homePageContent',
  //商城首页热卖商品拉取,
  'homePageBelowContent': serviceUrl + 'wxmini/homePageBelowConten',
  'getCategory': serviceUrl+'wxmini/getCategory', //商品类别信息
  'getMallGoods': serviceUrl+'wxmini/getMallGoods', //商品分类的商品列表
  'getGoodDetailById': serviceUrl+'wxmini/getGoodDetailById', //商品详细信息
};