import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_result.freezed.dart';

@freezed
abstract class TextResult with _$TextResult {
  const factory TextResult({
    required int id,
    required int documentId,
    required String text,
    required double confidence,
  }) = _TextResult;
}