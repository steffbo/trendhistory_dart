import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'packages/crypto/crypto.dart';
import 'packages/http/http.dart' as http;
//import 'package:mongo_dart/mongo_dart.dart';

final Map<String, String> config = getApiSecret();

const String BASE_URL = "https://api.twitter.com";
const String API_VERSION = "1.1";

const int BERLIN_WOEID = 638242;

main() {
  loadTrends();
}

String encode(String str) => CryptoUtils.bytesToBase64(UTF8.encode(str));

String getAuthString() => '${Uri.encodeFull(config['consumer_key'])}:${Uri.encodeFull(config['consumer_secret'])}';

getApiSecret() {
  File file = new File.fromUri(Uri.parse('resources/config.json'));
  String content = file.readAsStringSync();
  return JSON.decode(content);
}

void loadTrends() {
  requestBearerToken(getAuthString())
  .then((String bearer) => getTrends(bearer, BERLIN_WOEID))
  .then((List<Map> json) => listTrends(json));
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