import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/ocr_providers.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  XFile? _capturedImage;
  bool _isProcessing = false;
  String _documentTitle = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar Documento'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body:
          _capturedImage == null ? _buildCameraButton() : _buildImagePreview(),
    );
  }

  Widget _buildCameraButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Captura un documento para extraer su texto',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Icon(Icons.camera_alt, size: 100, color: Colors.black45),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar Fotografía'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen capturada
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_capturedImage!.path),
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Campo para título del documento
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título del documento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                enabled: !_isProcessing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
                onChanged: (value) {
                  _documentTitle = value;
                },
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          _isProcessing
                              ? null
                              : () {
                                setState(() {
                                  _capturedImage = null;
                                });
                              },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Volver a capturar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _processDocument,
                      icon:
                          _isProcessing
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Icons.text_fields),
                      label: Text(
                        _isProcessing ? 'Procesando...' : 'Extraer texto',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      // Utiliza directamente el ImagePicker para simplificar
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        setState(() {
          _capturedImage = photo;
        });
      }
    } catch (e) {
      _showErrorDialog('Error al capturar la imagen: ${e.toString()}');
    }
  }

  Future<void> _processDocument() async {
    if (!_formKey.currentState!.validate() || _capturedImage == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final ocrController = ref.read(ocrControllerProvider.notifier);
      final success = await ocrController.processDocument(
        _documentTitle,
        _capturedImage!.path,
      );

      if (success && mounted) {
        Navigator.pop(context, true);
      } else {
        _showErrorDialog('No se pudo procesar el documento.');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }
}
