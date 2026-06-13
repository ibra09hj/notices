import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notices/providers/news_provider.dart';

class UrlInputWidget extends StatefulWidget {
  const UrlInputWidget({Key? key}) : super(key: key);

  @override
  State<UrlInputWidget> createState() => _UrlInputWidgetState();
}

class _UrlInputWidgetState extends State<UrlInputWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitUrl() {
    final url = _controller.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa una URL')),
      );
      return;
    }
    context.read<NewsProvider>().verifyNewsUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Pega aquí la URL de la noticia...',
              prefixIcon: const Icon(Icons.link),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submitUrl(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _submitUrl,
              icon: const Icon(Icons.verified_user),
              label: const Text('Verificar Noticia'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pegá un enlace de cualquier noticia y te diremos si es confiable',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
