import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_scan_ticket/features/ocr/data/datasources/local_data_source.dart';
import '../../domain/repositories/ocr_repository.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/text_result.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/document_entity.dart';

class OcrRepositoryImpl implements OcrRepository {
  final TextRecognizer textRecognizer = TextRecognizer();
  final LocalDataSource
  _localDataSource; // Esto debe ser inyectado en el constructor

  OcrRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, XFile>> captureImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        return Left(OcrFailure(message: 'No se seleccionó ninguna imagen'));
      }

      return Right(pickedFile);
    } catch (e) {
      return Left(
        OcrFailure(message: 'Error al capturar imagen: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, TextResult>> extractText(
    String imagePath,
    int documentId,
  ) async {
    try {
      print(
        "Iniciando extracción de texto desde: $imagePath para documento ID: $documentId",
      );

      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await textRecognizer.processImage(inputImage);

      print("Texto extraído por OCR: ${recognizedText.text}");
      print("Longitud del texto: ${recognizedText.text.length}");
      print("Bloques encontrados: ${recognizedText.blocks.length}");

      // Mostrar detalles de bloques para depuración
      for (var block in recognizedText.blocks) {
        print("Bloque: ${block.text}");
        print("  Líneas: ${block.lines.length}");
        for (var line in block.lines) {
          print("    Línea: ${line.text}");
          print("      Elementos: ${line.elements.length}");
        }
      }

      // Si no hay texto reconocido, maneja el caso
      if (recognizedText.text.isEmpty) {
        print("⚠️ No se detectó texto en la imagen");
        return Left(OcrFailure(message: 'No se detectó texto en la imagen'));
      }

      // Crear un objeto de resultado
      final textResult = TextResult(
        id: DateTime.now().millisecondsSinceEpoch,
        documentId: documentId,
        text: recognizedText.text,
        confidence: 0.9, // Valor por defecto o calculado
      );

      // IMPORTANTE: Guardar el resultado en la base de datos
      try {
        await _localDataSource.saveTextResult(
          documentId,
          recognizedText.text,
          0.9, // Confianza
        );
        print("✅ Resultado de OCR guardado en la base de datos");
      } catch (dbError) {
        print("⚠️ Error al guardar resultado en base de datos: $dbError");
        // Puedes decidir si quieres fallar aquí o continuar
      }

      return Right(textResult);
    } catch (e) {
      print("❌ Error al extraer texto: $e");
      return Left(
        OcrFailure(message: 'Error al extraer texto: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Document>>> getAllDocuments() async {
    try {
      final documentEntities = await _localDataSource.getAllDocuments();
      final documents =
          documentEntities
              .map(
                (docEntity) => Document(
                  id: docEntity.id,
                  title: docEntity.title,
                  imagePath: docEntity.imagePath,
                  createdAt: docEntity.createdAt,
                ),
              )
              .toList();
      return Right(documents);
    } catch (e) {
      return Left(
        OcrFailure(message: 'Error al obtener documentos: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Document>> saveDocument(
    String title,
    String imagePath,
  ) async {
    try {
      final docEntity = DocumentEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        imagePath: imagePath,
        createdAt: DateTime.now(),
      );

      await _localDataSource.saveDocument(docEntity);

      final document = Document(
        id: docEntity.id,
        title: docEntity.title,
        imagePath: docEntity.imagePath,
        createdAt: docEntity.createdAt,
      );

      return Right(document);
    } catch (e) {
      return Left(
        OcrFailure(message: 'Error al guardar documento: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Document>>> searchDocuments(String query) async {
    try {
      final documents = await _localDataSource.searchDocuments(query);
      return Right(
        documents
            .map(
              (doc) => Document(
                id: doc.id,
                title: doc.title,
                imagePath: doc.imagePath,
                createdAt: doc.createdAt,
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Left(
        OcrFailure(message: 'Error al buscar documentos: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TextResult>>> getTextResultsForDocument(
    int documentId,
  ) async {
    try {
      final textResults = await _localDataSource.getTextResultsForDocument(
        documentId,
      );
      return Right(
        textResults
            .map(
              (text) => TextResult(
                id: text.id,
                documentId: documentId,
                text: text.text,
                confidence: text.confidence,
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Left(
        OcrFailure(
          message: 'Error al obtener resultados de texto: ${e.toString()}',
        ),
      );
    }
  }
}
