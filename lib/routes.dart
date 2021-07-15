import 'package:flutter/material.dart';
import 'package:professor/home/home_page_connector.dart';
import 'package:professor/login/login_connector.dart';
import 'package:professor/resource/resource_addedit_connector.dart';
import 'package:professor/resource/resource_connector.dart';
import 'package:professor/splash/splash_connector.dart';

class Routes {
  static final routes = {
    '/': (BuildContext context) => SplashConnector(),
    '/login': (BuildContext context) => LoginConnector(),
    '/home': (BuildContext context) => HomePageConnector(),
    '/resource': (BuildContext context) => ResourceConnector(
          moduleId: ModalRoute.of(context)!.settings.arguments.toString(),
        ),
    '/resource_addedit': (BuildContext context) => ResourceAddEditConnector(
          addOrEditId: ModalRoute.of(context)!.settings.arguments.toString(),
        ),
  };
}
