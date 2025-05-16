import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/document.dart';
import '../repositories/ocr_repository.dart';

class GetAllDocuments {
  final OcrRepository repository;

  GetAllDocuments(this.repository);

  Future<Either<Failure, List<Document>>> call() async {
    return await repository.getAllDocuments();
  }
}