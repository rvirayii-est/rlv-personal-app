import React from 'react';
import { createDrawerNavigator } from '@react-navigation/drawer';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';
import type { DrawerContentComponentProps } from '@react-navigation/drawer';
import type { DrawerParamList } from '../types/navigation';
import TabNavigator from './TabNavigator';
import SettingsScreen from '../screens/SettingsScreen';

const Drawer = createDrawerNavigator<DrawerParamList>();

// Custom Drawer Content Component
const CustomDrawerContent: React.FC<DrawerContentComponentProps> = (props) => {
  const { navigation } = props;
  
  const menuItems = [
    { name: 'Main', title: 'Home', icon: 'home' },
    { name: 'Settings', title: 'Settings', icon: 'settings' },
    { name: 'About', title: 'About', icon: 'info' },
    { name: 'Help', title: 'Help & Support', icon: 'help' },
  ];

  return (
    <View style={styles.drawerContainer}>
      {/* Header */}
      <View style={styles.drawerHeader}>
        <Icon name="account-circle" size={60} color="#2196F3" />
        <Text style={styles.headerTitle}>SuperTracker</Text>
        <Text style={styles.headerSubtitle}>Welcome back!</Text>
      </View>

      {/* Menu Items */}
      <View style={styles.drawerContent}>
        {menuItems.map((item, index) => (
          <TouchableOpacity
            key={index}
            style={styles.drawerItem}
            onPress={() => {
              if (item.name === 'Main' || item.name === 'Settings') {
                navigation.navigate(item.name);
              } else {
                // Handle other menu items here
                console.log(`Navigate to ${item.name}`);
              }
            }}
          >
            <Icon name={item.icon} size={24} color="#666" style={styles.drawerIcon} />
            <Text style={styles.drawerItemText}>{item.title}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {/* Footer */}
      <View style={styles.drawerFooter}>
        <TouchableOpacity style={styles.logoutButton}>
          <Icon name="logout" size={20} color="#ff4444" />
          <Text style={styles.logoutText}>Logout</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const DrawerNavigator: React.FC = () => {
  return (
    <Drawer.Navigator
      drawerContent={(props) => <CustomDrawerContent {...props} />}
      screenOptions={{
        drawerPosition: 'right',
        drawerStyle: {
          backgroundColor: '#f8f9fa',
          width: 280,
        },
        headerStyle: {
          backgroundColor: '#2196F3',
        },
        headerTintColor: '#fff',
        headerTitleStyle: {
          fontWeight: 'bold',
        },
      }}
    >
      <Drawer.Screen
        name="Main"
        component={TabNavigator}
        options={({ navigation }) => ({
          title: 'SuperTracker',
          headerRight: ({ tintColor }) => (
            <TouchableOpacity
              style={styles.headerButton}
              onPress={() => navigation.openDrawer()}
            >
              <Icon name="menu" size={24} color={tintColor} />
            </TouchableOpacity>
          ),
        })}
      />
      <Drawer.Screen 
        name="Settings" 
        component={SettingsScreen}
        options={{
          title: 'Settings',
        }}
      />
    </Drawer.Navigator>
  );
};

const styles = StyleSheet.create({
  drawerContainer: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  drawerHeader: {
    backgroundColor: '#2196F3',
    padding: 20,
    alignItems: 'center',
    paddingTop: 50,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#fff',
    marginTop: 10,
  },
  headerSubtitle: {
    fontSize: 14,
    color: '#e3f2fd',
    marginTop: 5,
  },
  drawerContent: {
    flex: 1,
    paddingTop: 20,
  },
  drawerItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  drawerIcon: {
    marginRight: 15,
  },
  drawerItemText: {
    fontSize: 16,
    color: '#333',
    fontWeight: '500',
  },
  drawerFooter: {
    padding: 20,
    borderTopWidth: 1,
    borderTopColor: '#e0e0e0',
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 12,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#ff4444',
  },
  logoutText: {
    marginLeft: 8,
    color: '#ff4444',
    fontWeight: '500',
  },
  headerButton: {
    marginRight: 15,
    padding: 5,
  },
});

export default DrawerNavigator;