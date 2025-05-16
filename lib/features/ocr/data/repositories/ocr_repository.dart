
import 'dart:io';
import '../entities/document_entity.dart';

// Interfaz para el repositorio OCR
abstract class OcrRepository {
  // Operaciones de documentos
  Future<List<DocumentEntity>> getAllDocuments();
  Future<DocumentEntity?> getDocumentById(String id);
  Future<void> saveDocument(DocumentEntity document);
  Future<void> deleteDocument(String id);
  Future<List<DocumentEntity>> searchDocumentsByText(String query);
  
  // Operaciones de OCR
  Future<String> extractTextFromImage(File imageFile);
  Future<File?> captureImage();
  Future<List<String>> getTextResultsForDocument(String documentId);
}