class BaseUrl {
  bool localdev = false;

  // user late to allows referencing localdev safely
  late String baseUrl = localdev
      ? 'http://192.168.1.101:8081'
      : 'http://38.242.243.27:8082';
}
