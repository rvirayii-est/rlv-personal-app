import '../database/database_helper.dart';

class User {
  int? id;
  String name;
  String email;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.id,
    required this.name,
    required this.email,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert User to Map for database
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnUserId: id,
      DatabaseHelper.columnUserName: name,
      DatabaseHelper.columnUserEmail: email,
      DatabaseHelper.columnUserCreatedAt: createdAt.toIso8601String(),
      DatabaseHelper.columnUserUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DatabaseHelper.columnUserId] as int?,
      name: map[DatabaseHelper.columnUserName] as String,
      email: map[DatabaseHelper.columnUserEmail] as String,
      createdAt: DateTime.parse(map[DatabaseHelper.columnUserCreatedAt] as String),
      updatedAt: DateTime.parse(map[DatabaseHelper.columnUserUpdatedAt] as String),
    );
  }

  // Copy with method for updating
  User copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode;
  }
}
