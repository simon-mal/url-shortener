import 'package:flutter/material.dart';
import 'package:url_redirector/plugin/router.dart';
import 'package:url_redirector/plugin/services.dart';
import 'package:url_redirector/services/html_service.dart';

class UrlRedirectorApp extends StatefulWidget {
  const UrlRedirectorApp({super.key});

  @override
  State<UrlRedirectorApp> createState() => _UrlRedirectorAppState();
}

class _UrlRedirectorAppState extends State<UrlRedirectorApp> {
  @override
  Widget build(BuildContext context) {
    return Services(
      htmlService: HtmlService(),
      child: MaterialApp(
        title: 'URL Redirector',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
