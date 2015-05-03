library trendhistory_mongo;

import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

/// Light wrapper class to provide methods for a MongoDB database.
class TrendDB {

  static const String _dbString = 'mongodb://localhost/admin';
  static const String _collectionName = 'trendhistory';

  Db _db;
  DbCollection _collection;

  /// Returns a [TrendDB] with default connection settings.
  TrendDB.fromDefault(){
    _db = new Db(_dbString);
    _collection = _db.collection(_collectionName);
  }

  /// Provide your own [dbString] to create a [Db] connection.
  /// You can also create a [DbCollection] using the Db.collection method.
  static Db getDb(String dbString) => new Db(dbString);

  /// Returns a [TrendDB] provided with your own [Db] and [DbCollection].
  /// [Db] and [DbCollection] are part of the mongo_dart library.
  TrendDB(this._db, this._collection);

  /// Saves a document in the [_collection] and
  /// returns a [Future<Map>] with the operations result provided by mongo_dart.
  Future<Map> saveDocument(Map document) async {
    await _db.open();
    var result = await _collection.save(document);
    await _db.close();
    return result;
  }

  /// Returns a [List] of all matching documents for the specified [selector].
  Future<List<Map>> showDocuments(Map selector) async {
    await _db.open();
    List<Map> list = await _collection.find(selector).toList();
    await _db.close();
    return list;
  }

}