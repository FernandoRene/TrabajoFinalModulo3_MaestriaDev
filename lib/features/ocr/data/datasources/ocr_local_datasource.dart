import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/document_model.dart';
import '../models/text_result_model.dart';

abstract class OcrLocalDataSource {
  Future<Database> get database;
  Future<DocumentModel> saveDocument(String title, String imagePath);
  Future<TextResultModel> saveTextResult(int documentId, String text, double confidence);
  Future<List<DocumentModel>> getAllDocuments();
  Future<List<TextResultModel>> getTextResultsForDocument(int documentId);
  Future<List<DocumentModel>> searchDocuments(String query);
}

class OcrLocalDataSourceImpl implements OcrLocalDataSource {
  static Database? _database;

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ocr_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE documents(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            image_path TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE text_results(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            document_id INTEGER NOT NULL,
            text TEXT NOT NULL,
            confidence REAL NOT NULL,
            FOREIGN KEY (document_id) REFERENCES documents (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  @override
  Future<DocumentModel> saveDocument(String title, String imagePath) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    final id = await db.insert(
      'documents',
      {
        'title': title,
        'image_path': imagePath,
        'created_at': now,
      },
    );

    return DocumentModel(
      id: id,
      title: title,
      imagePath: imagePath,
      createdAt: DateTime.parse(now),
    );
  }

  @override
  Future<TextResultModel> saveTextResult(int documentId, String text, double confidence) async {
    final db = await database;
    
    final id = await db.insert(
      'text_results',
      {
        'document_id': documentId,
        'text': text,
        'confidence': confidence,
      },
    );

    return TextResultModel(
      id: id,
      documentId: documentId,
      text: text,
      confidence: confidence,
    );
  }

  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await database;
    final results = await db.query(
      'documents',
      orderBy: 'created_at DESC',
    );

    return results.map((json) => DocumentModel.fromJson({
          'id': json['id'] as int,
          'title': json['title'] as String,
          'imagePath': json['image_path'] as String,
          'createdAt': DateTime.parse(json['created_at'] as String),
        })).toList();
  }

  @override
  Future<List<TextResultModel>> getTextResultsForDocument(int documentId) async {
    final db = await database;
    final results = await db.query(
      'text_results',
      where: 'document_id = ?',
      whereArgs: [documentId],
    );

    return results.map((json) => TextResultModel.fromJson({
          'id': json['id'] as int,
          'documentId': json['document_id'] as int,
          'text': json['text'] as String,
          'confidence': json['confidence'] as double,
        })).toList();
  }

  @override
  Future<List<DocumentModel>> searchDocuments(String query) async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT DISTINCT d.*
      FROM documents d
      JOIN text_results t ON d.id = t.document_id
      WHERE t.text LIKE ?
      ORDER BY d.created_at DESC
    ''', ['%$query%']);

    return results.map((json) => DocumentModel.fromJson({
          'id': json['id'] as int,
          'title': json['title'] as String,
          'imagePath': json['image_path'] as String,
          'createdAt': DateTime.parse(json['created_at'] as String),
        })).toList();
  }
}