import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ocr/data/datasources/local_data_source.dart';
import 'ocr/data/repositories/ocr_repository_impl.dart';
import 'ocr/domain/repositories/ocr_repository.dart';

// Proveedor para la fuente de datos local
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

// Proveedor para el repositorio OCR
final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return OcrRepositoryImpl(localDataSource);
});