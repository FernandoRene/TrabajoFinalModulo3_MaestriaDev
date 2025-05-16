class TextResultEntity {
  final int id;
  final int documentId;
  final String text;
  final double confidence;
  
  TextResultEntity({
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
  
  factory TextResultEntity.fromJson(Map<String, dynamic> json) {
    return TextResultEntity(
      id: json['id'],
      documentId: json['documentId'],
      text: json['text'],
      confidence: json['confidence'],
    );
  }
}