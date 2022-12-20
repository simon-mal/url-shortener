import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/models/url.dart';
import 'package:server/services/database_service.dart';

const connectionUrl =
    'mongodb+srv://serviceuser:test@cluster0.gw7q9xk.mongodb.net/url-shortener?retryWrites=true&w=majority';
const collectionName = 'urls';

class MongoDatabase implements Database {
  final Db _db;

  MongoDatabase._(this._db);

  DbCollection get collection => _db.collection(collectionName);

  static Future<MongoDatabase?> setup() async {
    try {
      final db = await _connect();
      return MongoDatabase._(db);
    } catch (e) {
      return null;
    }
  }

  static Future<Db> _connect() async {
    return await Db.create(connectionUrl)
      ..open();
  }

  Future<Url?> _getUrl(
    Map<String, dynamic> filter,
  ) async {
    final entry = await collection.findOne(filter);
    if (entry == null) {
      return null;
    }
    return Url.fromMap(entry);
  }

  @override
  Future<Url?> getByShortUrl(String searchUrl) async {
    return await _getUrl({
      Url.shortUrlFieldName: searchUrl,
    });
  }

  @override
  Future<Url?> getByLongUrl(
    String searchUrl, {
    bool ignoreParticular = false,
  }) async {
    return await _getUrl({
      Url.longUrlFieldName: searchUrl,
      if (ignoreParticular) Url.particularShortFieldName: false,
    });
  }

  @override
  Future<bool> createShortUrl({
    required String longUrl,
    required String shortUrl,
    bool particularShort = false,
  }) async {
    final url = Url(
      longUrl: longUrl,
      shortUrl: shortUrl,
      particularShort: particularShort,
    );
    final result = await collection.insertOne(url.toMap());
    return result.success;
  }
}
