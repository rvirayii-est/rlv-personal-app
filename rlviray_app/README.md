# RLViray App

A Flutter application with SQLite offline database support.

## Features

- SQLite local database for offline data storage
- Clean architecture with organized folder structure
- Provider state management
- Basic CRUD operations
- Sample models and database helper

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── database/              # Database related files
│   └── database_helper.dart
├── models/                # Data models
│   └── user.dart
├── screens/               # UI screens
│   ├── home_screen.dart
│   └── user_list_screen.dart
├── services/              # Business logic services
├── widgets/               # Reusable widgets
└── utils/                 # Utility functions and constants
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Database

This app uses SQLite (via sqflite package) for local data storage. The database helper is located in `lib/database/database_helper.dart`.

### Features:
- Singleton pattern for database instance
- CRUD operations
- Database versioning and migrations
- Async/await support

## Dependencies

- **sqflite**: SQLite plugin for Flutter
- **path_provider**: Access to file system paths
- **provider**: State management
- **intl**: Internationalization and date formatting
