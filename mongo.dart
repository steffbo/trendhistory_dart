import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

const String dbString = 'mongodb://localhost/admin';
const String collectionName = 'trendhistory';

main() {

  Db db = new Db(dbString);
  DbCollection collection = db.collection(collectionName);

  Map document = {'foo':'bar'};

  saveDocument(collection, document)
  .then((Map result) => print(result))

  .then((_) => showDocuments(collection, document)
  .then((List<Map> list) => list.forEach((e) => print(e))));

}

Future saveDocument(DbCollection collection, Map document) {

  return collection.db.open()
  .then((_) => collection.save(document))
  .then((result) {
    collection.db.close();
    return result;
  });
}

Future showDocuments(DbCollection collection, Map selector) {

  return collection.db.open()
  .then((_) => collection.find(selector).toList())
  .then((result) {
    collection.db.close();
    return result;
  });
}