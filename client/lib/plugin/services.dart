import 'package:flutter/material.dart';
import 'package:url_redirector/services/html_service.dart';

class Services extends InheritedWidget {
  final HtmlService htmlService;

  const Services({
    required this.htmlService,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  static Services of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
