import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/entities/text_result_entity.dart';

class LocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ocr_documents.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Crear tabla documentos
    await db.execute('''
      CREATE TABLE documents(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Crear tabla resultados de texto
    await db.execute('''
      CREATE TABLE text_results(
        id INTEGER PRIMARY KEY,
        documentId INTEGER NOT NULL,
        text TEXT NOT NULL,
        confidence REAL NOT NULL,
        FOREIGN KEY (documentId) REFERENCES documents (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<List<DocumentEntity>> getAllDocuments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return DocumentEntity(
        id: maps[i]['id'],
        title: maps[i]['title'],
        imagePath: maps[i]['imagePath'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  Future<void> saveDocument(DocumentEntity document) async {
    final db = await database;
    await db.insert('documents', {
      'id': document.id,
      'title': document.title,
      'imagePath': document.imagePath,
      'createdAt': document.createdAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DocumentEntity>> searchDocuments(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT d.* FROM documents d
      LEFT JOIN text_results t ON d.id = t.documentId
      WHERE d.title LIKE ? OR t.text LIKE ?
      GROUP BY d.id
      ORDER BY d.createdAt DESC
    ''',
      ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return DocumentEntity(
        id: maps[i]['id'],
        title: maps[i]['title'],
        imagePath: maps[i]['imagePath'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  Future<void> saveTextResult(
    int documentId,
    String text,
    double confidence,
  ) async {
    final db = await database;

    await db.insert(
      'text_results', // Nombre de la tabla
      {
        'id': DateTime.now().millisecondsSinceEpoch, // ID único
        'documentId': documentId,
        'text': text,
        'confidence': confidence,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TextResultEntity>> getTextResultsForDocument(
    int documentId,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'text_results',
      where: 'documentId = ?',
      whereArgs: [documentId],
    );

    return List.generate(maps.length, (i) {
      return TextResultEntity(
        id: maps[i]['id'],
        documentId: maps[i]['documentId'],
        text: maps[i]['text'],
        confidence: maps[i]['confidence'],
      );
    });
  }
}
