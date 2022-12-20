import 'dart:async';
import 'dart:io';

import 'package:server/services/request_handler/request_handler.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class Webserver {
  final HttpServer _server;

  Webserver._(this._server);

  static Future<Webserver> run(RequestHandler requestHandler) async {
    final server =
        await shelf_io.serve(requestHandler.handler, 'localhost', 8000);
    print('Server is up and listening on localhost:8000');
    return Webserver._(server);
  }

  Future<void> close() async {
    await _server.close();
  }
}
