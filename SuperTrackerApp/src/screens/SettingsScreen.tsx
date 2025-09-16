import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Switch } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import type { DrawerNavigationProp } from '@react-navigation/drawer';
import type { DrawerParamList } from '../types/navigation';
import Icon from 'react-native-vector-icons/MaterialIcons';
import type { SettingsScreenProps } from '../types/navigation';

const SettingsScreen: React.FC<SettingsScreenProps> = () => {
  const navigation = useNavigation<DrawerNavigationProp<DrawerParamList>>();
  const [notificationsEnabled, setNotificationsEnabled] = React.useState<boolean>(true);
  const [darkModeEnabled, setDarkModeEnabled] = React.useState<boolean>(false);

  const openDrawer = () => {
    navigation.openDrawer();
  };

  return (
    <View style={styles.container}>
      {/* Custom Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Settings</Text>
        <TouchableOpacity style={styles.drawerButton} onPress={openDrawer}>
          <Icon name="menu" size={24} color="#fff" />
        </TouchableOpacity>
      </View>

      {/* Content */}
      <ScrollView style={styles.content} contentContainerStyle={styles.contentContainer}>
        {/* General Settings */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>General</Text>
          
          <View style={styles.settingItem}>
            <Icon name="notifications" size={24} color="#666" />
            <Text style={styles.settingText}>Notifications</Text>
            <Switch
              value={notificationsEnabled}
              onValueChange={setNotificationsEnabled}
              trackColor={{ false: '#ccc', true: '#2196F3' }}
            />
          </View>

          <View style={styles.settingItem}>
            <Icon name="dark-mode" size={24} color="#666" />
            <Text style={styles.settingText}>Dark Mode</Text>
            <Switch
              value={darkModeEnabled}
              onValueChange={setDarkModeEnabled}
              trackColor={{ false: '#ccc', true: '#2196F3' }}
            />
          </View>
        </View>

        {/* Account Settings */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Account</Text>
          
          <TouchableOpacity style={styles.settingItem}>
            <Icon name="person" size={24} color="#666" />
            <Text style={styles.settingText}>Profile</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>

          <TouchableOpacity style={styles.settingItem}>
            <Icon name="security" size={24} color="#666" />
            <Text style={styles.settingText}>Privacy & Security</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>
        </View>

        {/* Support Settings */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Support</Text>
          
          <TouchableOpacity style={styles.settingItem}>
            <Icon name="help" size={24} color="#666" />
            <Text style={styles.settingText}>Help & FAQ</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>

          <TouchableOpacity style={styles.settingItem}>
            <Icon name="feedback" size={24} color="#666" />
            <Text style={styles.settingText}>Send Feedback</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>

          <TouchableOpacity style={styles.settingItem}>
            <Icon name="info" size={24} color="#666" />
            <Text style={styles.settingText}>About</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    backgroundColor: '#2196F3',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    paddingTop: 40,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#fff',
  },
  drawerButton: {
    padding: 8,
  },
  content: {
    flex: 1,
  },
  contentContainer: {
    padding: 16,
  },
  section: {
    backgroundColor: '#fff',
    borderRadius: 12,
    marginBottom: 16,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    padding: 16,
    paddingBottom: 8,
  },
  settingItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  settingText: {
    flex: 1,
    fontSize: 16,
    color: '#333',
    marginLeft: 16,
  },
});

export default SettingsScreen;
