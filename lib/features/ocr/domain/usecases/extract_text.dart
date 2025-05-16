import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/text_result.dart';
import '../repositories/ocr_repository.dart';

class ExtractText {
  final OcrRepository repository;

  ExtractText(this.repository);

  Future<Either<Failure, TextResult>> call(String imagePath, int documentId) async {
    return await repository.extractText(imagePath, documentId);
  }
}