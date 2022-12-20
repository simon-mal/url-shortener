import 'dart:math';

class ShortUrlGenerator {
  const ShortUrlGenerator._();

  static const length = 8;

  static String generate() {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(length, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
