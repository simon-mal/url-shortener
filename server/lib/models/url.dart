class Url {
  static const shortUrlFieldName = 'shortUrl';
  static const longUrlFieldName = 'longUrl';
  static const particularShortFieldName = 'particularShort';

  final String shortUrl;
  final String longUrl;
  final bool particularShort;

  const Url({
    required this.longUrl,
    required this.shortUrl,
    this.particularShort = false,
  });

  static Url fromMap(Map<String, dynamic> map) {
    final shortUrl = map[shortUrlFieldName];
    final longUrl = map[longUrlFieldName];
    final particularShort = map[particularShortFieldName];
    return Url(
      longUrl: longUrl,
      shortUrl: shortUrl,
      particularShort: particularShort,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      shortUrlFieldName: shortUrl,
      longUrlFieldName: longUrl,
      particularShortFieldName: particularShort,
    };
  }
}
