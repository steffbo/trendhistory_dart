import 'dart:async';

import 'lib/mongo.dart';
import 'lib/twitter.dart';

main() async {

  // Mongo DB wrapper
  TrendDB db = new TrendDB.fromDefault();
  Map selector = {'foo': 'bar'};
  List<Map> res = await db.showDocuments(selector);
  res.forEach((e) => print(e));


  // Twitter API wrapper
  TrendTwitter trendTwitter = new TrendTwitter();
  List<Map> trends = await trendTwitter.getTrends(TrendTwitter.BERLIN_WOEID);
  listTrends(trends);
}


listTrends(List<Map> map) {

  map.forEach((e) {
    List<Map> trendList = e['trends'];
    trendList.forEach((e) {
      print(e['name']);
    });
  });
}