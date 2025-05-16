import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/document.dart';
import '../repositories/ocr_repository.dart';

class SaveDocument {
  final OcrRepository repository;

  SaveDocument(this.repository);

  Future<Either<Failure, Document>> call(String title, String imagePath) async {
    return await repository.saveDocument(title, imagePath);
  }
}