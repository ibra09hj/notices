import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notices/providers/news_provider.dart';
import 'package:notices/widgets/url_input_widget.dart';
import 'package:notices/widgets/verification_result_widget.dart';
import 'package:notices/widgets/history_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Fact Checker'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Verificar'),
            Tab(icon: Icon(Icons.history), text: 'Historial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVerificationTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildVerificationTab() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const UrlInputWidget(),
              const SizedBox(height: 30),
              if (newsProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: SpinKitCircle(
                    color: Colors.blue,
                    size: 60,
                  ),
                )
              else if (newsProvider.error != null)
                _buildErrorWidget(context, newsProvider)
              else if (newsProvider.currentVerification != null)
                VerificationResultWidget(
                  verification: newsProvider.currentVerification!,
                )
              else
                _buildEmptyState(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, _) {
        return HistoryListWidget(
          verifications: newsProvider.history,
          onClearHistory: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Limpiar historial'),
                content: const Text('¿Estás seguro de que deseas eliminar todo el historial?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      newsProvider.clearHistory();
                      Navigator.pop(context);
                    },
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, NewsProvider newsProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.red.shade400, size: 40),
            const SizedBox(height: 12),
            Text(
              newsProvider.error ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: newsProvider.clearError,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Ingresa una URL para verificar',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
