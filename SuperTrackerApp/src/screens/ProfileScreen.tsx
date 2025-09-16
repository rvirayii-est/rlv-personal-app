import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import type { DrawerNavigationProp } from '@react-navigation/drawer';
import type { DrawerParamList } from '../types/navigation';
import Icon from 'react-native-vector-icons/MaterialIcons';
import type { ProfileScreenProps } from '../types/navigation';

const ProfileScreen: React.FC<ProfileScreenProps> = () => {
  const navigation = useNavigation<DrawerNavigationProp<DrawerParamList>>();

  const openDrawer = () => {
    navigation.openDrawer();
  };

  return (
    <View style={styles.container}>
      {/* Custom Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Profile</Text>
        <TouchableOpacity style={styles.drawerButton} onPress={openDrawer}>
          <Icon name="menu" size={24} color="#fff" />
        </TouchableOpacity>
      </View>

      {/* Content */}
      <ScrollView style={styles.content} contentContainerStyle={styles.contentContainer}>
        {/* Profile Card */}
        <View style={styles.profileCard}>
          <Icon name="account-circle" size={80} color="#2196F3" />
          <Text style={styles.profileName}>John Doe</Text>
          <Text style={styles.profileEmail}>john.doe@example.com</Text>
        </View>

        {/* Profile Options */}
        <View style={styles.optionsContainer}>
          <TouchableOpacity style={styles.optionItem}>
            <Icon name="edit" size={24} color="#666" />
            <Text style={styles.optionText}>Edit Profile</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>

          <TouchableOpacity style={styles.optionItem}>
            <Icon name="notifications" size={24} color="#666" />
            <Text style={styles.optionText}>Notifications</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>

          <TouchableOpacity style={styles.optionItem}>
            <Icon name="security" size={24} color="#666" />
            <Text style={styles.optionText}>Privacy & Security</Text>
            <Icon name="chevron-right" size={24} color="#ccc" />
          </TouchableOpacity>

          <TouchableOpacity style={styles.optionItem}>
            <Icon name="help" size={24} color="#666" />
            <Text style={styles.optionText}>Help & Support</Text>
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
  profileCard: {
    backgroundColor: '#fff',
    padding: 24,
    borderRadius: 12,
    alignItems: 'center',
    marginBottom: 24,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  profileName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginTop: 16,
    marginBottom: 4,
  },
  profileEmail: {
    fontSize: 16,
    color: '#666',
  },
  optionsContainer: {
    backgroundColor: '#fff',
    borderRadius: 12,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  optionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  optionText: {
    flex: 1,
    fontSize: 16,
    color: '#333',
    marginLeft: 16,
  },
});

export default ProfileScreen;
