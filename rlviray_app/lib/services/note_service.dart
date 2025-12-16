import '../database/database_helper.dart';
import '../models/note.dart';

class NoteService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create a new note
  Future<int> createNote(Note note) async {
    note.updatedAt = DateTime.now();
    return await _dbHelper.insert(
      DatabaseHelper.tableNotes,
      note.toMap(),
    );
  }

  // Get all notes
  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      DatabaseHelper.tableNotes,
      orderBy: '${DatabaseHelper.columnNoteUpdatedAt} DESC',
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // Get note by id
  Future<Note?> getNoteById(int id) async {
    final map = await _dbHelper.queryById(
      DatabaseHelper.tableNotes,
      id,
      DatabaseHelper.columnNoteId,
    );
    return map != null ? Note.fromMap(map) : null;
  }

  // Get notes by user id
  Future<List<Note>> getNotesByUserId(int userId) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tableNotes,
      '${DatabaseHelper.columnNoteUserId} = ?',
      [userId],
      orderBy: '${DatabaseHelper.columnNoteUpdatedAt} DESC',
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // Update note
  Future<int> updateNote(Note note) async {
    note.updatedAt = DateTime.now();
    return await _dbHelper.update(
      DatabaseHelper.tableNotes,
      note.toMap(),
      note.id!,
      DatabaseHelper.columnNoteId,
    );
  }

  // Delete note
  Future<int> deleteNote(int id) async {
    return await _dbHelper.delete(
      DatabaseHelper.tableNotes,
      id,
      DatabaseHelper.columnNoteId,
    );
  }

  // Get note count
  Future<int> getNoteCount() async {
    return await _dbHelper.getCount(DatabaseHelper.tableNotes);
  }

  // Search notes by title or content
  Future<List<Note>> searchNotes(String searchTerm) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tableNotes,
      '${DatabaseHelper.columnNoteTitle} LIKE ? OR ${DatabaseHelper.columnNoteContent} LIKE ?',
      ['%$searchTerm%', '%$searchTerm%'],
      orderBy: DatabaseHelper.columnNoteUpdatedAt,
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // Delete all notes for a user
  Future<int> deleteNotesByUserId(int userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableNotes,
      where: '${DatabaseHelper.columnNoteUserId} = ?',
      whereArgs: [userId],
    );
  }
}
