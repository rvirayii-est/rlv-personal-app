# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Flutter (if not already installed)

Visit: https://docs.flutter.dev/get-started/install

**Quick check:**
```bash
flutter --version
```

If you see the version, Flutter is installed! ✅

### Step 2: Create local.properties File

Create `android/local.properties` with:
```properties
flutter.sdk=C:/src/flutter
```
(Replace with your actual Flutter SDK path)

### Step 3: Get Dependencies

```bash
cd rlviray_app
flutter pub get
```

### Step 4: Run the App

```bash
flutter run
```

That's it! 🎉

## 📱 What You'll See

The app includes:
- ✅ Home screen with statistics
- ✅ User management (Create, Read, Update, Delete)
- ✅ Note management with search
- ✅ SQLite database (offline storage)
- ✅ Clean architecture and code organization

## 🔧 Common Issues

**Problem**: `flutter: command not found`
**Solution**: Install Flutter SDK and add to PATH

**Problem**: Android build fails
**Solution**: Run `flutter doctor` and fix reported issues

**Problem**: Can't find device
**Solution**:
- Android: Start an emulator or connect a device
- iOS: Open iOS Simulator (macOS only)
- Web: Will auto-open browser
- Windows: Should work automatically

## 📖 Key Files

- `lib/main.dart` - App entry point
- `lib/database/database_helper.dart` - SQLite setup
- `lib/models/` - Data models (User, Note)
- `lib/services/` - Business logic
- `lib/screens/` - UI screens

## 🎯 Next Steps

1. Explore the code structure
2. Try adding/editing users and notes
3. Check the database helper for SQLite operations
4. Customize the UI theme in `lib/main.dart`
5. Add your own models and services

## 💡 Pro Tips

- Press `r` for hot reload while developing
- Press `R` for hot restart
- Run `flutter doctor` to check setup
- Use `flutter clean` if builds fail

## 🆘 Need Help?

Read the detailed [SETUP_GUIDE.md](SETUP_GUIDE.md) for:
- Complete installation instructions
- Detailed project structure
- Database schema
- Troubleshooting guide
- Advanced features

Happy coding! 🚀
