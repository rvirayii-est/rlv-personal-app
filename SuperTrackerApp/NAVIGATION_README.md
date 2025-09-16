# SuperTracker Navigation Template

This document explains the navigation structure and components in your SuperTracker app.

## Navigation Structure

```
App.tsx
└── DrawerNavigator (Right-side drawer)
    ├── Main (TabNavigator)
    │   ├── Home Tab
    │   ├── Feed Tab
    │   └── Profile Tab
    └── Settings Screen
```

## Features Implemented

### ✅ Bottom Tab Navigation
- **Location**: `src/navigation/TabNavigator.js`
- **Features**:
  - Material Design icons for each tab
  - Custom styling with blue accent color
  - Three main tabs: Home, Feed, Profile
  - Proper tab bar height and padding

### ✅ Right Collapsible Drawer
- **Location**: `src/navigation/DrawerNavigator.js`
- **Features**:
  - Opens from the right side
  - Custom drawer content with header, menu items, and footer
  - User profile section at the top
  - Menu items with icons
  - Logout button at the bottom
  - 280px width with custom styling

### ✅ Enhanced Screens
All screens now include:
- Custom headers with app branding
- Drawer toggle button in the top-right
- Consistent styling and layout
- Material Design icons throughout

## Key Components

### TabNavigator
```javascript
// Handles bottom navigation with 3 tabs
// Icons change based on focused state
// Custom tab bar styling
```

### DrawerNavigator
```javascript
// Right-side drawer with custom content
// Profile header, menu items, logout footer
// Connects to main tab navigation
```

### Screen Templates
Each screen follows a consistent pattern:
- Header with title and drawer toggle
- ScrollView content area
- Material Design styling
- Responsive layout

## Customization Options

### Colors
- Primary: `#2196F3` (Blue)
- Success: `#4CAF50` (Green)
- Warning: `#FF9800` (Orange)
- Error: `#ff4444` (Red)

### Icons
Using `react-native-vector-icons/MaterialIcons`:
- Tab icons: home, dynamic-feed, person
- Menu icons: settings, info, help, logout
- Action icons: add, analytics, history

### Drawer Menu Items
Currently includes:
- Home (navigates to main tabs)
- Settings (separate screen)
- About (placeholder)
- Help & Support (placeholder)
- Logout (placeholder)

## Usage Examples

### Opening the Drawer
```javascript
import { useNavigation } from '@react-navigation/native';

const navigation = useNavigation();
navigation.openDrawer();
```

### Navigation Between Tabs
```javascript
navigation.navigate('Home');
navigation.navigate('Feed');
navigation.navigate('Profile');
```

### Navigation to Drawer Screens
```javascript
navigation.navigate('Settings');
```

## Next Steps

To extend this template:

1. **Add more tabs**: Edit `TabNavigator.js` and add new screens
2. **Add drawer items**: Edit the `menuItems` array in `DrawerNavigator.js`
3. **Customize styling**: Modify the `styles` objects in each file
4. **Add functionality**: Connect buttons to actual features
5. **Convert to TypeScript**: Add proper type definitions for navigation

## Dependencies

Make sure these packages are installed:
- `@react-navigation/native`
- `@react-navigation/bottom-tabs`
- `@react-navigation/drawer`
- `react-native-vector-icons`
- `react-native-screens`
- `react-native-safe-area-context`

## File Structure

```
src/
├── navigation/
│   ├── DrawerNavigator.js    # Right-side drawer navigation
│   └── TabNavigator.js       # Bottom tab navigation
└── screens/
    ├── HomeScreen.js         # Main dashboard screen
    ├── FeedScreen.js         # Activity feed screen
    ├── ProfileScreen.js      # User profile screen
    └── SettingsScreen.js     # App settings screen
```

Your navigation template is now ready to use! 🚀
