import 'package:flutter/material.dart';
import 'package:professor/home/home_page_connector.dart';
import 'package:professor/login/login_connector.dart';
import 'package:professor/splash/splash_connector.dart';

class Routes {
  static final routes = {
    '/': (BuildContext context) => SplashConnector(),
    '/login': (BuildContext context) => LoginConnector(),
    '/home': (BuildContext context) => HomePageConnector(),
  };
}
