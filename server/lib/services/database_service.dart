import 'dart:async';

import 'package:server/models/url.dart';
import 'package:server/services/id_gernator.dart';

abstract class DatabaseService {
  /// returns a long url to which we can redirect
  /// returns null if the url could not be resolved.
  Future<String?> onShortUrl(String shortUrl);

  /// returns a short url if successfully created or an existing one was found.
  /// returns null if an error occurs.
  Future<String?> onCreateUrl(
    String longUrl, {
    String? particularShort,
  });

  /// returns a url to redirect to.
  Future<String> onRootRequest();
}

abstract class Database {
  Future<Url?> getByShortUrl(String url);

  Future<Url?> getByLongUrl(
    String url, {
    bool ignoreParticular = false,
  });

  Future<bool> createShortUrl({
    required String longUrl,
    required String shortUrl,
    bool particularShort = false,
  });
}

class MongoDBService extends DatabaseService {
  final Database database;

  MongoDBService(this.database);

  @override
  Future<String?> onCreateUrl(
    String longUrl, {
    String? particularShort,
  }) async {
    if (particularShort != null) {
      return _onCreateParticular(
        longUrl: longUrl,
        particularShort: particularShort,
      );
    }
    return _onCreateRandom(longUrl);
  }

  @override
  Future<String?> onShortUrl(String shortUrl) async {
    final url = await database.getByShortUrl(shortUrl);
    return url?.longUrl;
  }

  @override
  Future<String> onRootRequest() async {
    // change this to actual domain once deployed
    return 'https://localhost:5000';
  }

  Future<String?> _onCreateParticular({
    required String longUrl,
    required String particularShort,
  }) async {
    final existingShort = await database.getByShortUrl(particularShort);
    if (existingShort != null) {
      return null;
    }
    final created = await database.createShortUrl(
      longUrl: longUrl,
      shortUrl: particularShort,
      particularShort: true,
    );
    if (created) {
      return particularShort;
    }
    return null;
  }

  Future<String?> _onCreateRandom(String longUrl) async {
    print('on create random');
    final existing = await database.getByLongUrl(
      longUrl,
      ignoreParticular: true,
    );
    if (existing != null) {
      return existing.shortUrl;
    }

    final shortUrl = ShortUrlGenerator.generate();
    await database.createShortUrl(
      longUrl: longUrl,
      shortUrl: shortUrl,
    );
    return shortUrl;
  }
}
