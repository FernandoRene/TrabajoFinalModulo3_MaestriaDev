import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ocr_providers.dart';
import '../widgets/document_item.dart';
import 'document_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(documentsNotifierProvider);

    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar texto en documentos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        if (_isSearching) {
                          ref.read(documentsNotifierProvider.notifier).refreshDocuments();
                          setState(() {
                            _isSearching = false;
                          });
                        }
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && value.length > 2) {
                _performSearch(value);
              } else if (value.isEmpty && _isSearching) {
                ref.read(documentsNotifierProvider.notifier).refreshDocuments();
                setState(() {
                  _isSearching = false;
                });
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _performSearch(value);
              }
            },
          ),
        ),
        
        // Resultados de búsqueda
        Expanded(
          child: documentsAsync.when(
            data: (documents) {
              if (documents.isEmpty && _isSearching) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron resultados',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Intenta con otra búsqueda',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (documents.isEmpty && !_isSearching) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        size: 80,
                        color: Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Busca texto en tus documentos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Escribe en la barra de búsqueda para encontrar documentos',
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
        ),
      ],
    );
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });
    ref.read(documentsNotifierProvider.notifier).performSearch(query);
  }
}