import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_redirector/plugin/services.dart';
import 'package:url_redirector/services/url_correction.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final urlController = TextEditingController();
  final shortUrlController = TextEditingController();
  String? _resultUrl;
  String? _shortUrlErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL-Shortener'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 48),
            _buildInputRow(),
            const SizedBox(height: 16),
            _buildParticularUrlRow(),
            const SizedBox(height: 16),
            _buildButtonRow(),
            const SizedBox(height: 16),
            if (_resultUrl != null) _buildResultRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        'Füge deinen Link in das Textfeld ein und erhalte einen short-link.',
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.headline5?.fontSize,
        ),
      ),
    );
  }

  Widget _buildInputRow() {
    const horizontalPadding = 200.0;
    const exampleUrl = 'https://localhost:5000';
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  helperText: 'Link einfügen',
                  border: OutlineInputBorder(),
                  hintText: exampleUrl,
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticularUrlRow() {
    const horizontalPadding = 200.0;
    const example = 'myCustomUrl123';
    return Center(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: shortUrlController,
                  decoration: const InputDecoration(
                    helperText: 'Gewünschten Kurzlink einfügen',
                    border: OutlineInputBorder(),
                    hintText: example,
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  maxLength: 30,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                ),
              ),
              const SizedBox(
                width: 32,
              ),
            ],
          )),
    );
  }

  Widget _buildButtonRow() {
    const horizontalPadding = 200.0;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ElevatedButton.icon(
          onPressed: () =>
              urlController.text.isNotEmpty ? _onCreateShortUrl() : null,
          icon: const Icon(Icons.arrow_right_alt_outlined),
          label: const Text('Los'),
        ),
      ),
    );
  }

  Widget _buildResultRow() {
    const horizontalPadding = 200.0;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _resultUrl),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                  errorText: _shortUrlErrorText,
                ),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            ElevatedButton.icon(
              onPressed: _onCopyShortUrl,
              icon: const Icon(Icons.copy),
              label: const Text('Kopieren'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreateShortUrl() async {
    final htmlService = Services.of(context).htmlService;
    final url = urlController.text.trim();
    final trimmedRequested = shortUrlController.text.trim();
    final isValid = trimmedRequested.isNotEmpty;
    final requestedShortUrl = isValid ? trimmedRequested : null;
    final shortUrl = await htmlService.shortenUrl(
      url,
      requestedShortUrl: requestedShortUrl,
    );
    if (shortUrl == null) {
      return;
    }
    setState(() {
      _resultUrl = shortUrl;
    });
  }

  Future<void> _onCopyShortUrl() async {
    await Clipboard.setData(ClipboardData(text: _resultUrl));
  }
}
