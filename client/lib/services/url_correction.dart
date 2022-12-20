class UrlCorrector {
  UrlCorrector._();
  static String withHost(String input) {
    // if the url is entered in the form of `example.com` enrich it to `http://example.com`
    if (_isValid(input)) {
      return input;
    }
    const prefix = 'http://';
    return prefix + input;
  }

  static bool _isValid(String input) {
    return input.startsWith('http://') || input.startsWith('https://');
  }
}
