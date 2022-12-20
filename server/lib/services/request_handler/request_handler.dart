import 'dart:async';
import 'dart:convert';
import 'package:server/extensions.dart';
import 'package:server/services/database_service.dart';

import 'package:shelf/shelf.dart';

abstract class RequestHandler {
  Handler get handler;
}

class ShortUrlRequestHandler implements RequestHandler {
  final DatabaseService service;

  ShortUrlRequestHandler(this.service);

  @override
  Handler get handler {
    final cascade = Cascade()
        .add(_onApiRequestHandler)
        .add(_onShortUrlRequestHandler)
        .add(_onRootRequest)
        .add(_onBadRequestHandler)
        .handler;
    return Pipeline().addMiddleware(logRequests()).addHandler(cascade);
  }

  FutureOr<Response> _onApiRequestHandler(Request request) async {
    if (!request.isApiRequest) {
      return Response.notFound('did not match api pattern ${request.url.path}');
    }
    if (!request.isCreateRequest) {
      return Response.notFound(
          'did not match any known pattern ${request.url.path}');
    }
    final Map<String, dynamic> body =
        await json.decode(await request.readAsString());
    final target = body['target'];
    if (target == null) {
      return Response.badRequest();
    }
    final action = request.url.pathSegments[2];
    switch (action) {
      case 'random':
        final shortUrl = await _handleCreateRandom(target);
        if (shortUrl == null) {
          return Response.notFound('could not create a short url');
        }
        return Response.ok('localhost:8000/$shortUrl');
      case 'particular':
        final requested = body['requested'];
        if (requested == null) {
          return Response.badRequest(body: 'requested url has to be set');
        }
        final shortUrl = await _handleCreateParticular(
          target: target,
          particularShort: requested,
        );
        if (shortUrl == null) {
          return Response.badRequest(
            body: 'could not create requested shorturl',
          );
        }
        return Response.ok('localhost:8000/$shortUrl');
    }
    return Response.notFound(
        'did not match any known api request: ${request.url.path}');
  }

  Future<String?> _handleCreateRandom(String target) async {
    return await service.onCreateUrl(target);
  }

  Future<String?> _handleCreateParticular({
    required String target,
    required String particularShort,
  }) async {
    return await service.onCreateUrl(
      target,
      particularShort: particularShort,
    );
  }

  FutureOr<Response> _onShortUrlRequestHandler(Request request) async {
    if (!request.isShortUrlRequest) {
      return Response.notFound(
          'did not match shortUrl pattern ${request.url.path}');
    }
    final shortUrl = request.url.pathSegments.first;
    final longUrl = await service.onShortUrl(shortUrl);
    if (longUrl == null) {
      return Response.notFound('did not find the short url: $shortUrl');
    }
    final uri = Uri.tryParse(longUrl);
    if (uri == null) {
      return Response.notFound('afsafd');
    }
    return Response.found(uri);
  }

  FutureOr<Response> _onRootRequest(Request request) async {
    if (!request.isRootRequest) {
      return Response.notFound(
          'did not match root pattern ${request.url.path}');
    }
    final redirect = await service.onRootRequest();
    return Response.found(redirect);
  }

  FutureOr<Response> _onBadRequestHandler(Request request) async {
    return Response.badRequest();
  }
}
