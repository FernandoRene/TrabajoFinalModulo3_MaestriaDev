import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'features/ocr/data/datasources/camera_datasource.dart';
import 'features/ocr/data/datasources/ocr_local_datasource.dart';
import 'features/ocr/data/repositories/ocr_repository_impl.dart';
import 'features/ocr/domain/repositories/ocr_repository.dart';

// Datasources
final ocrLocalDataSourceProvider = Provider<OcrLocalDataSource>((ref) {
  return OcrLocalDataSourceImpl();
});

final cameraDataSourceProvider = Provider<CameraDataSource>((ref) {
  return CameraDataSourceImpl();
});

// ML Kit Text Recognizer
final textRecognizerProvider = Provider<TextRecognizer>((ref) {
  return TextRecognizer(script: TextRecognitionScript.latin);
});

// Repository
final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return OcrRepositoryImpl(
    localDataSource: ref.watch(ocrLocalDataSourceProvider),
    cameraDataSource: ref.watch(cameraDataSourceProvider),
    textRecognizer: ref.watch(textRecognizerProvider),
  );
});