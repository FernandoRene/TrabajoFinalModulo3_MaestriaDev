import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/document.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

@freezed
class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required int id,
    required String title,
    required String imagePath,
    required DateTime createdAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) => _$DocumentModelFromJson(json);

  factory DocumentModel.fromEntity(Document document) => DocumentModel(
        id: document.id,
        title: document.title,
        imagePath: document.imagePath,
        createdAt: document.createdAt,
      );
}

extension DocumentModelX on DocumentModel {
  Document toEntity() => Document(
        id: id,
        title: title,
        imagePath: imagePath,
        createdAt: createdAt,
      );
}