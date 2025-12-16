import '../database/database_helper.dart';

class Note {
  int? id;
  String title;
  String? content;
  int? userId;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    this.content,
    this.userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert Note to Map for database
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnNoteId: id,
      DatabaseHelper.columnNoteTitle: title,
      DatabaseHelper.columnNoteContent: content,
      DatabaseHelper.columnNoteUserId: userId,
      DatabaseHelper.columnNoteCreatedAt: createdAt.toIso8601String(),
      DatabaseHelper.columnNoteUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  // Create Note from Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[DatabaseHelper.columnNoteId] as int?,
      title: map[DatabaseHelper.columnNoteTitle] as String,
      content: map[DatabaseHelper.columnNoteContent] as String?,
      userId: map[DatabaseHelper.columnNoteUserId] as int?,
      createdAt: DateTime.parse(map[DatabaseHelper.columnNoteCreatedAt] as String),
      updatedAt: DateTime.parse(map[DatabaseHelper.columnNoteUpdatedAt] as String),
    );
  }

  // Copy with method for updating
  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ content.hashCode ^ userId.hashCode;
  }
}
