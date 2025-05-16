import 'dart:io';
import '../../domain/repositories/ocr_repository.dart';

class CaptureImage {
  final OcrRepository repository;

  CaptureImage(this.repository);

  Future<File?> call() async {
    return await repository.captureImage();
  }
}