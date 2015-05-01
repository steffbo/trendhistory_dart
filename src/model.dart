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