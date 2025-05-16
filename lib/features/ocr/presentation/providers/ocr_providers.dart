import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/text_result.dart';
import '../../domain/usecases/get_all_documents.dart';
import '../../domain/usecases/save_document.dart';
import '../../domain/usecases/search_documents.dart';
import '../../domain/usecases/extract_text.dart';
import '../../domain/repositories/ocr_repository.dart';
import '../../../repositories.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

// Proveedores para casos de uso
final getAllDocumentsUseCaseProvider = Provider<GetAllDocuments>((ref) {
  return GetAllDocuments(ref.watch(ocrRepositoryProvider));
});

final saveDocumentUseCaseProvider = Provider<SaveDocument>((ref) {
  return SaveDocument(ref.watch(ocrRepositoryProvider));
});

final searchDocumentsUseCaseProvider = Provider<SearchDocuments>((ref) {
  return SearchDocuments(ref.watch(ocrRepositoryProvider));
});

final extractTextUseCaseProvider = Provider<ExtractText>((ref) {
  return ExtractText(ref.watch(ocrRepositoryProvider));
});

// Proveedor para el notifier de documentos
final documentsNotifierProvider =
    StateNotifierProvider<DocumentsNotifier, AsyncValue<List<Document>>>((ref) {
      final repository = ref.watch(ocrRepositoryProvider);
      final getAllDocuments = ref.watch(getAllDocumentsUseCaseProvider);
      final saveDocument = ref.watch(saveDocumentUseCaseProvider);
      final searchDocuments = ref.watch(searchDocumentsUseCaseProvider);

      return DocumentsNotifier(
        repository: repository,
        getAllDocuments: getAllDocuments,
        saveDocument: saveDocument,
        searchDocuments: searchDocuments,
      );
    });

class DocumentsNotifier extends StateNotifier<AsyncValue<List<Document>>> {
  final OcrRepository repository;
  final GetAllDocuments getAllDocuments;
  final SaveDocument saveDocument;
  final SearchDocuments searchDocuments;

  DocumentsNotifier({
    required this.repository,
    required this.getAllDocuments,
    required this.saveDocument,
    required this.searchDocuments,
  }) : super(const AsyncValue.loading()) {
    refreshDocuments();
  }

  Future<void> refreshDocuments() async {
    state = const AsyncValue.loading();
    final result = await getAllDocuments();
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (documents) => AsyncValue.data(documents),
    );
  }

  Future<void> performSearch(String query) async {
    state = const AsyncValue.loading();
    final result = await repository.searchDocuments(query);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (documents) => AsyncValue.data(documents),
    );
  }

  Future<bool> saveNewDocument(String title, String imagePath) async {
    final result = await saveDocument(title, imagePath);
    return result.fold((failure) => false, (document) {
      refreshDocuments();
      return true;
    });
  }
}

// Estado para el controlador OCR
class OcrState {
  final File? image;
  final String? extractedText;
  final bool isProcessing;
  final String? error;
  final bool isSaving;
  final bool savedSuccessfully;

  OcrState({
    this.image,
    this.extractedText,
    this.isProcessing = false,
    this.error,
    this.isSaving = false,
    this.savedSuccessfully = false,
  });

  OcrState copyWith({
    File? image,
    String? extractedText,
    bool? isProcessing,
    String? error,
    bool? isSaving,
    bool? savedSuccessfully,
  }) {
    return OcrState(
      image: image ?? this.image,
      extractedText: extractedText ?? this.extractedText,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
      isSaving: isSaving ?? this.isSaving,
      savedSuccessfully: savedSuccessfully ?? this.savedSuccessfully,
    );
  }
}

// Controlador para OCR
class OcrController extends StateNotifier<OcrState> {
  final Ref ref;

  OcrController(this.ref) : super(OcrState());

  Future<bool> processDocument(String title, String imagePath) async {
    try {
      final saveDocumentUseCase = ref.read(saveDocumentUseCaseProvider);
      final document = await saveDocumentUseCase(title, imagePath);

      return document.fold((failure) => false, (doc) async {
        final extractTextUseCase = ref.read(extractTextUseCaseProvider);
        final textResult = await extractTextUseCase(imagePath, doc.id);
        return textResult.isRight();
      });
    } catch (e) {
      return false;
    }
  }

  void reset() {
    state = OcrState();
  }
}

// Proveedor para el controlador OCR
final ocrControllerProvider = StateNotifierProvider<OcrController, OcrState>((
  ref,
) {
  return OcrController(ref);
});
