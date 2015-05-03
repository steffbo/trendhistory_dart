import 'lib/mongo.dart';
import 'lib/twitter.dart';

main() async {

  // Mongo DB wrapper
  TrendDB db = new TrendDB.fromDefault();
  Map selector = {'foo': 'bar'};
  List<Map> documents = await db.showDocuments(selector);
  documents.forEach((e) => print(e));


  // Twitter API wrapper
  TrendTwitter trendTwitter = new TrendTwitter();
  Map trends = await trendTwitter.getTrends(TrendTwitter.WORLD_WOEID);
  listTrends(trends);

  await db.saveDocument(trends);
}


listTrends(Map trends) {
  List<Map> trendList = trends['trends'];
  trendList.forEach((e) {
    print(e['name']);
  });
}