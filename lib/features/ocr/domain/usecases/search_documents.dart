import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/document.dart';
import '../repositories/ocr_repository.dart';

class SearchDocuments {
  final OcrRepository repository;

  SearchDocuments(this.repository);

  Future<Either<Failure, List<Document>>> call(String query) async {
    return await repository.searchDocuments(query);
  }
}