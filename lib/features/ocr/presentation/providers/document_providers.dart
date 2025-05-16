import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_all_documents.dart';
import '../../domain/usecases/search_text.dart';
import '../../../repositories.dart';

// Estado para el proveedor de documentos
class DocumentsState {
  final List<dynamic> documents;
  final bool isLoading;
  final String? error;

  DocumentsState({
    this.documents = const [],
    this.isLoading = false,
    this.error,
  });

  DocumentsState copyWith({
    List<dynamic>? documents,
    bool? isLoading,
    String? error,
  }) {
    return DocumentsState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Proveedor de estado para documentos
final documentsProvider =
    StateNotifierProvider<DocumentsNotifier, DocumentsState>((ref) {
      final getAllDocuments = ref.watch(getAllDocumentsProvider);
      return DocumentsNotifier(getAllDocuments);
    });

// Notificador que maneja el estado de documentos
class DocumentsNotifier extends StateNotifier<DocumentsState> {
  final GetAllDocuments _getAllDocuments;

  DocumentsNotifier(this._getAllDocuments) : super(DocumentsState()) {
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final documents = await _getAllDocuments();
      documents.fold(
        (failure) =>
            state = state.copyWith(error: failure.message, isLoading: false),
        (documentsList) =>
            state = state.copyWith(documents: documentsList, isLoading: false),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// Proveedores para casos de uso (sin usar riverpod_generator)
final getAllDocumentsProvider = Provider<GetAllDocuments>((ref) {
  return GetAllDocuments(ref.watch(ocrRepositoryProvider));
});

final searchTextProvider = Provider<SearchText>((ref) {
  return SearchText(ref.watch(ocrRepositoryProvider));
});
