import 'package:flutter/material.dart';
import 'package:professor/home/controller/home_page_connector.dart';
import 'package:professor/login/controller/login_connector.dart';
import 'package:professor/module/controller/module_archived_connector.dart';
import 'package:professor/resource/controller/resource_addedit_connector.dart';
import 'package:professor/resource/controller/resource_connector.dart';
import 'package:professor/splash/controller/splash_connector.dart';

class Routes {
  static final routes = {
    '/': (BuildContext context) => SplashConnector(),
    '/login': (BuildContext context) => LoginConnector(),
    '/home': (BuildContext context) => HomePageConnector(),
    '/module_archived': (BuildContext context) => ModuleArchivedConnector(),
    '/resource': (BuildContext context) => ResourceConnector(
          moduleId: ModalRoute.of(context)!.settings.arguments.toString(),
        ),
    '/resource_addedit': (BuildContext context) => ResourceAddEditConnector(
          addOrEditId: ModalRoute.of(context)!.settings.arguments.toString(),
        ),
  };
}
