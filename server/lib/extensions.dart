import 'package:shelf/shelf.dart';

extension RequestChecker on Request {
  bool get isApiRequest {
    print('encoding is null: ${encoding == null}');
    return url.path.startsWith('api/') &&
        url.pathSegments.length == 3 &&
        encoding != null &&
        method == 'POST';
  }

  bool get isCreateRequest =>
      url.path.startsWith('api/create') &&
      url.pathSegments.length == 3 &&
      encoding != null &&
      method == 'POST';

  bool get isShortUrlRequest =>
      url.path.isNotEmpty &&
      url.pathSegments.length == 1 &&
      encoding == null &&
      method == 'GET';

  bool get isRootRequest =>
      url.path.isEmpty && encoding == null && method == 'GET';
}
