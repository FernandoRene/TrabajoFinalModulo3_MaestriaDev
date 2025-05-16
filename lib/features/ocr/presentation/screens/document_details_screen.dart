import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/document.dart';
import '../providers/ocr_providers.dart';
import '../../../repositories.dart';

class DocumentDetailsScreen extends ConsumerStatefulWidget {
  final Document document;

  const DocumentDetailsScreen({Key? key, required this.document})
    : super(key: key);

  @override
  ConsumerState<DocumentDetailsScreen> createState() =>
      _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends ConsumerState<DocumentDetailsScreen> {
  String? _documentText;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDocumentText();
  }

  Future<void> _loadDocumentText() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(ocrRepositoryProvider);
      final result = await repository.getTextResultsForDocument(widget.document.id);

      result.fold(
        (failure) {
          setState(() {
            _documentText = "Error al obtener texto: ${failure.message}";
            _isLoading = false;
          });
        },
        (textResults) {
          setState(() {
            _documentText = textResults.isNotEmpty
                ? textResults.first.text
                : "No hay texto disponible";
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.document.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información del documento
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fecha: ${widget.document.createdAt.toLocal().toString().split(' ')[0]}",
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Contenido del documento
                      const Text(
                        "Contenido:",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _documentText ?? "Cargando texto...",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),

                      // Mostrar imagen
                      const SizedBox(height: 16.0),
                      const Text(
                        "Imagen:",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(widget.document.imagePath),
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}