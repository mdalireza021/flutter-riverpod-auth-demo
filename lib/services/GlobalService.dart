import 'package:flutter/cupertino.dart';

class GlobalService {
  static final GlobalService _instance = GlobalService._internal();

  late String _deviceId, _authToken, _fcmToken;
  GlobalKey<NavigatorState>? navigatorKey;
  // passes the instantiation to the _instance object
  factory GlobalService() => _instance;

  GlobalService._internal() {
    _deviceId = '';
    _authToken = '';
    _fcmToken = '';
    navigatorKey = GlobalKey<NavigatorState>();
  }

  void setDeviceId(String id) => _deviceId = id;
  String getDeviceId() => _deviceId;
  void setAuthToken(String token) => _authToken = token;
  String getAuthToken() => _authToken;

}