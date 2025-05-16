import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/document.dart';
import '../entities/text_result.dart';
import '../../../../core/errors/failures.dart';

abstract class OcrRepository {
  /// Captura una imagen desde la cámara
  Future<Either<Failure, XFile>> captureImage();
  
  /// Extrae texto de una imagen
  Future<Either<Failure, TextResult>> extractText(String imagePath, int documentId);
  
  /// Guarda un nuevo documento con su imagen
  Future<Either<Failure, Document>> saveDocument(String title, String imagePath);
  
  /// Obtiene todos los documentos
  Future<Either<Failure, List<Document>>> getAllDocuments();
  
  /// Obtiene los resultados de texto para un documento
  Future<Either<Failure, List<TextResult>>> getTextResultsForDocument(int documentId);
  
  /// Busca documentos que contengan el texto especificado
  Future<Either<Failure, List<Document>>> searchDocuments(String query);
}