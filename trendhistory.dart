import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'packages/crypto/crypto.dart';
import 'packages/http/http.dart' as http;

final String consumer_key = "Ba2ByaZNXoc7XVKFSb3ciPXH9";
final String consumer_secret = "LFRLssfZieLWLe3730fTgvK2KQ86yueqG5GUzo58O17HWCaFRe";
//final String access_token_key = "2879262400-fSyafXGHJ9pEZ3VaFFPrbyUQB4kSJPTyHdrcYsM";
//final String access_token_secret = "YeUK31pzBom3F1gQZdbEhA3Pm3ettAkFfbHjz5n03xyKi";

const String BASE_URL = "https://api.twitter.com";
const String API_VERSION = "1.1";

const int BERLIN_WOEID = 638242;

class Location {
  String city;
  int woeid;

  Location(this.city, this.woeid);
}

class TrendMoment {
  Location location;
  DateTime datetime;
  List<String> trends;

  TrendMoment(this.location, this.datetime, this.trends);
}

class Trend {
  Location location;
  DateTime datetime;
  String trend;

  Trend.fromParams(this.location, this.datetime, this.trend);
}

main() {
//  loadTrends();
  getApiSecret();
}

String encode(String str) => CryptoUtils.bytesToBase64(UTF8.encode(str));

String getAuthString() => '${Uri.encodeFull(consumer_key)}:${Uri.encodeFull(consumer_secret)}';

void loadTrends() {
  requestBearerToken(getAuthString())
  .then((String bearer) => getTrends(bearer, BERLIN_WOEID))
  .then((List<Map> json) => listTrends(json));
}

getApiSecret() {
  File file = new File.fromUri(Uri.parse('resources/config.json'));
  String content = file.readAsStringSync();
  Map<String, String> config = JSON.decode(content);
  print('key: ${config['consumer_key']}');
  print('secret: ${config['consumer_secret']}');
}

Future<String> requestBearerToken(String auth) {

  final String endpoint = '$BASE_URL/oauth2/token';
  final Map<String, String> headers = {
    'Authorization': 'Basic ${encode(auth)}',
    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
  };
  final String body = "grant_type=client_credentials";

  return http.post(endpoint, headers : headers, body : body, encoding : UTF8)
  .then((response) {
    print('response from $endpoint: ${response.body}');
    Map obj = JSON.decode(response.body);
    return obj['access_token'];
  });
}

/// Returns current twitter trends for a location specified by [woeid].
Future<List<Map>> getTrends(String bearer, int woeid) {

  final String endpoint = '$BASE_URL/$API_VERSION/trends/place.json';
  final Map<String, String> headers = {
    'Authorization': 'Bearer $bearer'
  };

  String url = '$endpoint?id=$woeid';

  return http.get(url, headers: headers)
  .then((response) {
    print('response from $url: ${response.body}');
    List<Map> obj = JSON.decode(response.body);
    return obj;
  });

}

listTrends(List<Map> map) {

  map.forEach((e) {
    List<Map> trendList = e['trends'];
    trendList.forEach((e) {
      print(e['name']);
    });
  });

}