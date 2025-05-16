class TextResultModel {
  final int id;
  final int documentId;
  final String text;
  final double confidence;

  TextResultModel({
    required this.id,
    required this.documentId,
    required this.text,
    required this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'text': text,
      'confidence': confidence,
    };
  }

  factory TextResultModel.fromJson(Map<String, dynamic> json) {
    return TextResultModel(
      id: json['id'],
      documentId: json['documentId'],
      text: json['text'],
      confidence: json['confidence'],
    );
  }

  // Método para convertir a la entidad de dominio si la tienes
  TextResult toEntity() {
    return TextResult(
      id: id,
      documentId: documentId,
      text: text,
      confidence: confidence,
    );
  }

  // Método para crear desde la entidad de dominio si la tienes
  factory TextResultModel.fromEntity(TextResult entity) {
    return TextResultModel(
      id: entity.id,
      documentId: entity.documentId,
      text: entity.text,
      confidence: entity.confidence,
    );
  }
}