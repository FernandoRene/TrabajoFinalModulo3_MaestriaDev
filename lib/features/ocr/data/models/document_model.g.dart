// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    _DocumentModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DocumentModelToJson(_DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imagePath': instance.imagePath,
      'createdAt': instance.createdAt.toIso8601String(),
    };
