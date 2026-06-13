import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notices/models/news_verification.dart';
import 'package:notices/providers/news_provider.dart';
import 'package:intl/intl.dart';

class HistoryListWidget extends StatelessWidget {
  final List<NewsVerification> verifications;
  final VoidCallback onClearHistory;

  const HistoryListWidget({Key? key, required this.verifications, required this.onClearHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (verifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No hay verificaciones guardadas', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${verifications.length} verificaciones', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
              ElevatedButton.icon(
                onPressed: onClearHistory,
                icon: const Icon(Icons.delete),
                label: const Text('Limpiar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: verifications.length,
            itemBuilder: (context, index) => _buildHistoryItem(context, verifications[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, NewsVerification verification) {
    final color = verification.credibility.getColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color.withOpacity(0.3), width: 1)),
        child: InkWell(
          onTap: () => _showDetails(context, verification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text(verification.credibility.getEmoji(), style: const TextStyle(fontSize: 20))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(verification.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(verification.domain ?? 'Desconocido', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        '${verification.credibility.score.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(verification.verificationDate),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'delete') {
                          context.read<NewsProvider>().removeFromHistory(verification.url);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verificación eliminada'), duration: Duration(seconds: 2)));
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 16), SizedBox(width: 8), Text('Eliminar')]))
                      ],
                      child: Icon(Icons.more_vert, size: 16, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, NewsVerification verification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text(verification.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: verification.credibility.getColor().withOpacity(0.1),
                    border: Border.all(color: verification.credibility.getColor().withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Puntuación: ${verification.credibility.score.toStringAsFixed(1)}/100', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(verification.credibility.category, style: TextStyle(color: verification.credibility.getColor(), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(verification.credibility.reason, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5)),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))),
              ],
            ),
          ),
        );
      },
    );
  }
}
