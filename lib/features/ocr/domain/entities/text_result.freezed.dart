// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextResult {

 int get id; int get documentId; String get text; double get confidence;
/// Create a copy of TextResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextResultCopyWith<TextResult> get copyWith => _$TextResultCopyWithImpl<TextResult>(this as TextResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextResult&&(identical(other.id, id) || other.id == id)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.text, text) || other.text == text)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,id,documentId,text,confidence);

@override
String toString() {
  return 'TextResult(id: $id, documentId: $documentId, text: $text, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $TextResultCopyWith<$Res>  {
  factory $TextResultCopyWith(TextResult value, $Res Function(TextResult) _then) = _$TextResultCopyWithImpl;
@useResult
$Res call({
 int id, int documentId, String text, double confidence
});




}
/// @nodoc
class _$TextResultCopyWithImpl<$Res>
    implements $TextResultCopyWith<$Res> {
  _$TextResultCopyWithImpl(this._self, this._then);

  final TextResult _self;
  final $Res Function(TextResult) _then;

/// Create a copy of TextResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? documentId = null,Object? text = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _TextResult implements TextResult {
  const _TextResult({required this.id, required this.documentId, required this.text, required this.confidence});
  

@override final  int id;
@override final  int documentId;
@override final  String text;
@override final  double confidence;

/// Create a copy of TextResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextResultCopyWith<_TextResult> get copyWith => __$TextResultCopyWithImpl<_TextResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextResult&&(identical(other.id, id) || other.id == id)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.text, text) || other.text == text)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,id,documentId,text,confidence);

@override
String toString() {
  return 'TextResult(id: $id, documentId: $documentId, text: $text, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$TextResultCopyWith<$Res> implements $TextResultCopyWith<$Res> {
  factory _$TextResultCopyWith(_TextResult value, $Res Function(_TextResult) _then) = __$TextResultCopyWithImpl;
@override @useResult
$Res call({
 int id, int documentId, String text, double confidence
});




}
/// @nodoc
class __$TextResultCopyWithImpl<$Res>
    implements _$TextResultCopyWith<$Res> {
  __$TextResultCopyWithImpl(this._self, this._then);

  final _TextResult _self;
  final $Res Function(_TextResult) _then;

/// Create a copy of TextResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? documentId = null,Object? text = null,Object? confidence = null,}) {
  return _then(_TextResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
