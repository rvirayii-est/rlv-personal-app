# Flutter Project Setup Guide

## Overview
This is a complete Flutter application with SQLite offline database support. The project has been manually created with all necessary files and configurations.

## Prerequisites

Before running this project, you need to install:

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://docs.flutter.dev/get-started/install
   - Follow the installation guide for your operating system

2. **Android Studio** (for Android development)
   - Download from: https://developer.android.com/studio
   - Install Android SDK and configure

3. **Xcode** (for iOS development - macOS only)
   - Install from Mac App Store

4. **Git** (recommended)
   - Download from: https://git-scm.com/

## Installation Steps

### 1. Install Flutter SDK

**Windows:**
```bash
# Download Flutter SDK and extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin
```

**macOS/Linux:**
```bash
# Download Flutter SDK and extract
export PATH="$PATH:`pwd`/flutter/bin"
```

Verify installation:
```bash
flutter --version
flutter doctor
```

### 2. Fix Issues Reported by Flutter Doctor

Run `flutter doctor` and follow the instructions to install any missing dependencies.

### 3. Configure Flutter SDK Path

Create a `local.properties` file in the `android` folder:

```properties
# Path to your Flutter SDK
flutter.sdk=/path/to/your/flutter/sdk

# Example on Windows:
# flutter.sdk=C:\\src\\flutter

# Example on macOS/Linux:
# flutter.sdk=/Users/username/flutter
```

### 4. Install Dependencies

Navigate to the project directory and run:

```bash
cd rlviray_app
flutter pub get
```

### 5. Run the Application

**For Android:**
```bash
flutter run
```

**For iOS (macOS only):**
```bash
cd ios
pod install
cd ..
flutter run
```

**For Web:**
```bash
flutter run -d chrome
```

**For Windows Desktop:**
```bash
flutter run -d windows
```

## Project Structure

```
rlviray_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── database/
│   │   └── database_helper.dart     # SQLite database helper (Singleton)
│   ├── models/
│   │   ├── user.dart                # User model
│   │   └── note.dart                # Note model
│   ├── services/
│   │   ├── user_service.dart        # User CRUD operations
│   │   └── note_service.dart        # Note CRUD operations
│   ├── screens/
│   │   ├── home_screen.dart         # Home screen with stats
│   │   ├── user_list_screen.dart    # User management screen
│   │   └── note_list_screen.dart    # Note management screen
│   ├── widgets/                     # Reusable widgets
│   └── utils/
│       ├── constants.dart           # App constants and colors
│       └── validators.dart          # Input validation utilities
├── android/                         # Android-specific files
├── ios/                            # iOS-specific files
├── test/                           # Unit and widget tests
├── pubspec.yaml                    # Dependencies and assets
├── README.md                       # Project documentation
└── SETUP_GUIDE.md                  # This file

```

## Key Features

### 1. Database Helper (Singleton Pattern)
- Single database instance throughout the app
- Generic CRUD operations
- Database versioning and migrations support
- Foreign key constraints

### 2. Models
- **User Model**: id, name, email, timestamps
- **Note Model**: id, title, content, userId (FK), timestamps
- Model to Map conversion for database operations
- Factory constructors for creating from database

### 3. Services Layer
- **UserService**: Create, read, update, delete users
- **NoteService**: Manage notes with user relationships
- Search functionality
- Count operations

### 4. UI Screens
- **Home Screen**: Dashboard with statistics
- **User List Screen**: Full CRUD for users with search
- **Note List Screen**: Note management with search and detail view

### 5. Utilities
- Input validators (email, name, password, phone, URL)
- App constants and color schemes
- Date formatting utilities

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
```

### Notes Table
```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT,
  user_id INTEGER,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
)
```

## Dependencies

The project uses the following packages:

- **sqflite**: ^2.3.0 - SQLite database
- **path**: ^1.8.3 - Path manipulation
- **path_provider**: ^2.1.1 - File system access
- **provider**: ^6.1.1 - State management
- **intl**: ^0.18.1 - Internationalization and date formatting

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run app in debug mode
flutter run

# Build APK for Android
flutter build apk

# Build iOS app
flutter build ios

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .

# Clean build
flutter clean
```

## Troubleshooting

### Issue: "flutter: command not found"
**Solution**: Add Flutter SDK bin directory to your PATH environment variable

### Issue: Android licenses not accepted
**Solution**:
```bash
flutter doctor --android-licenses
```

### Issue: Gradle build fails
**Solution**:
- Check your Android SDK installation
- Verify ANDROID_HOME environment variable
- Update Gradle in android/gradle/wrapper/gradle-wrapper.properties

### Issue: Pod install fails (iOS)
**Solution**:
```bash
cd ios
pod repo update
pod install --repo-update
cd ..
```

### Issue: SQLite errors
**Solution**:
- Delete the app from device/emulator
- Run `flutter clean`
- Rebuild the app

## Development Tips

1. **Hot Reload**: Press 'r' in terminal during development
2. **Hot Restart**: Press 'R' in terminal
3. **DevTools**: Run `flutter pub global activate devtools` then `flutter pub global run devtools`
4. **VS Code Extensions**: Install Flutter and Dart extensions
5. **Android Studio**: Install Flutter and Dart plugins

## Testing

Run all tests:
```bash
flutter test
```

Run specific test:
```bash
flutter test test/widget_test.dart
```

## Building for Production

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Next Steps

1. Add user authentication
2. Implement data synchronization
3. Add image storage
4. Implement backup/restore
5. Add more complex queries
6. Implement pagination
7. Add unit tests for services
8. Add integration tests

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Sqflite Package](https://pub.dev/packages/sqflite)
- [Flutter Samples](https://flutter.github.io/samples/)

## Support

For issues or questions:
1. Check Flutter documentation
2. Search on Stack Overflow
3. Check GitHub issues for sqflite package
4. Review Flutter community forums

## License

This project is for personal use.
