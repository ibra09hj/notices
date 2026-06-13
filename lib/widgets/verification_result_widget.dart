import 'package:flutter/material.dart';
import 'package:notices/models/news_verification.dart';
import 'package:intl/intl.dart';

class VerificationResultWidget extends StatelessWidget {
  final NewsVerification verification;

  const VerificationResultWidget({Key? key, required this.verification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreCard(),
            const SizedBox(height: 20),
            _buildAnalysisCard(),
            const SizedBox(height: 20),
            _buildFactorsCard(),
            const SizedBox(height: 20),
            _buildSourcesCard(),
            const SizedBox(height: 20),
            _buildRecommendationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    final color = verification.credibility.getColor();
    final emoji = verification.credibility.getEmoji();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            '${verification.credibility.score.toStringAsFixed(1)}/100',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              verification.credibility.category,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Análisis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              verification.credibility.reason,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (verification.domain != null)
              Row(
                children: [
                  Icon(Icons.language, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      verification.domain ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(verification.verificationDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Factores Analizados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...verification.credibility.factors.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatFactorName(entry.key), style: const TextStyle(fontSize: 13)),
                        Text('${entry.value.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: entry.value / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(_getFactorColor(entry.value)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSourcesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fuentes Consultadas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (verification.sources.isEmpty)
              Text('No se encontraron fuentes', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic))
            else
              ...verification.sources.map((source) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(source.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: source.verified ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                source.confidence,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: source.verified ? Colors.green.shade700 : Colors.orange.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(_formatSourceType(source.type), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard() {
    final isRecommended = verification.isTrustworthy;

    return Container(
      decoration: BoxDecoration(
        color: isRecommended ? Colors.green.shade50 : Colors.orange.shade50,
        border: Border.all(color: isRecommended ? Colors.green.shade200 : Colors.orange.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isRecommended ? Icons.check_circle : Icons.warning, color: isRecommended ? Colors.green.shade700 : Colors.orange.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isRecommended ? 'Recomendado' : 'No Recomendado',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isRecommended ? Colors.green.shade700 : Colors.orange.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isRecommended
                ? 'Esta noticia proviene de una fuente relativamente confiable. Aún así, siempre es bueno verificar múltiples fuentes.'
                : 'Se recomienda verificar esta noticia con múltiples fuentes antes de compartirla o confiar en ella.',
            style: TextStyle(
              fontSize: 13,
              color: isRecommended ? Colors.green.shade700 : Colors.orange.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFactorName(String key) {
    const names = {
      'dominio': '🌐 Dominio',
      'ssl': '🔒 Seguridad SSL',
      'fact_checks': '✓ Fact-Checks',
      'noticias_similares': '📰 Noticias Similares',
      'contenido': '📝 Contenido',
    };
    return names[key] ?? key;
  }

  String _formatSourceType(String type) {
    const types = {
      'fact_check': 'Verificación de hechos',
      'news_db': 'Base de datos de noticias',
      'domain_analysis': 'Análisis de dominio',
    };
    return types[type] ?? type;
  }

  Color _getFactorColor(double value) {
    if (value >= 75) return Colors.green;
    if (value >= 50) return Colors.amber;
    return Colors.red;
  }
}
