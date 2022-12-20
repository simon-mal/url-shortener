import 'dart:convert';

import 'package:http/http.dart';
import 'package:url_redirector/services/url_correction.dart';

class HtmlService {
  static const createRandomRequest = 'api/create/random';
  static const createParticularRequest = 'api/create/particular';

  Map<String, dynamic> _createRandomBody(String target) => {'target': target};
  Map<String, dynamic> _createParticularBody(String target, String requested) =>
      {
        'target': target,
        'requested': requested,
      };

  Future<String?> shortenUrl(
    String longUrl, {
    String? requestedShortUrl,
  }) async {
    final client = Client();
    final withHost = UrlCorrector.withHost(longUrl);
    final longUri = Uri.tryParse(withHost);
    if (longUri == null) {
      return null;
    }
    final method = requestedShortUrl != null
        ? createParticularRequest
        : createRandomRequest;
    final body = requestedShortUrl != null
        ? _createParticularBody(withHost, requestedShortUrl)
        : _createRandomBody(withHost);
    try {
      final request = Uri.http('localhost:8000', method);
      final response = await client.post(
        request,
        body: json.encode(body),
      );
      final shortUrl = response.body;
      return shortUrl;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }
}
