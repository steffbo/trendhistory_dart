library trendhistory_twitter;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

class TrendTwitter {

  final Map<String, String> _config = _getConfig();

  static const String _BASE_URL = "https://api.twitter.com";
  static const String _API_VERSION = "1.1";

  static const int WORLD_WOEID = 1;
  static const int BERLIN_WOEID = 638242;

  TrendTwitter();

  static _getConfig() {
    File file = new File.fromUri(Uri.parse('resources/config.json'));
    String content = file.readAsStringSync();
    return JSON.decode(content);
  }

  static String _encode(String str) => CryptoUtils.bytesToBase64(UTF8.encode(str));

  String _getAuthString() => '${Uri.encodeFull(_config['consumer_key'])}:${Uri.encodeFull(_config['consumer_secret'])}';

  Future<String> _getAccessToken() async {
    final String endpoint = '$_BASE_URL/oauth2/token';

    String authString = _getAuthString();

    final Map<String, String> headers = {
      'Authorization': 'Basic ${_encode(authString)}',
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
    };
    final String body = "grant_type=client_credentials";

    Response response = await http.post(endpoint, headers : headers, body : body, encoding : UTF8);
    print('response from $endpoint: ${response.body}');
    Map obj = JSON.decode(response.body);
    return obj['access_token'];
  }

  /// Returns current twitter trends for a location specified by [woeid].
  Future<Map> getTrends(int woeid) async {

    String authToken = await _getAccessToken();

    final String endpoint = '$_BASE_URL/$_API_VERSION/trends/place.json';
    final Map<String, String> headers = {'Authorization': 'Bearer $authToken'};
    String url = '$endpoint?id=$woeid';

    Response response = await http.get(url, headers: headers);
    print('response from $url: ${response.body}');
    List<Map> obj = JSON.decode(response.body);
    return obj.first;
  }

}