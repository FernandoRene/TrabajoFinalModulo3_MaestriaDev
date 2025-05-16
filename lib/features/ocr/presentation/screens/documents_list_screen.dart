import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ocr_providers.dart';
import 'document_details_screen.dart';
import '../widgets/document_item.dart';

class DocumentsListScreen extends ConsumerWidget {
  const DocumentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(documentsNotifierProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(documentsNotifierProvider.notifier).refreshDocuments();
      },
      child: documentsAsync.when(
        data: (documents) {
          if (documents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 80,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay documentos escaneados',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Presiona el botón de cámara para escanear un documento',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return DocumentItem(
                document: document,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DocumentDetailsScreen(document: document),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}