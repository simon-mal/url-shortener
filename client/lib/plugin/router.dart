import 'package:flutter/material.dart';
import 'package:url_redirector/screens/start_page.dart';

const startPage = '/';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case startPage:
        return AppRoute(builder: ((_) => const StartPage()));
      default:
        return AppRoute(builder: ((_) => const StartPage()));
    }
  }
}

class AppRoute<T> extends MaterialPageRoute<T> implements Route<T> {
  AppRoute({required super.builder});
}
