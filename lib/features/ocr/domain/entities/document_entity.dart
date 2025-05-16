class DocumentEntity {
  final int id;
  final String title;
  final String imagePath;
  final DateTime createdAt;
  
  DocumentEntity({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.createdAt,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory DocumentEntity.fromJson(Map<String, dynamic> json) {
    return DocumentEntity(
      id: json['id'],
      title: json['title'],
      imagePath: json['imagePath'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}