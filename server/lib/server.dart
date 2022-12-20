import 'package:server/database/database.dart';
import 'package:server/services/database_service.dart';
import 'package:server/services/request_handler/request_handler.dart';
import 'package:server/webserver/webserver.dart';

const connectionUrl =
    'mongodb+srv://serviceuser:test@cluster0.gw7q9xk.mongodb.net/url-shortener?retryWrites=true&w=majority';
const collectionName = 'urls';

void start() async {
  final mongoDb = await MongoDatabase.setup();
  if (mongoDb == null) {
    throw Exception('coudl not start server: coudl not setup mongoDB');
  }

  final dbService = MongoDBService(mongoDb);
  final handler = ShortUrlRequestHandler(dbService);
  await Webserver.run(handler);
}
