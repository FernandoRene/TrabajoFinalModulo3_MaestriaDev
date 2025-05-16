import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';

@freezed
abstract class Document with _$Document {
  const factory Document({
    required int id,
    required String title,
    required String imagePath,
    required DateTime createdAt,
  }) = _Document;
}