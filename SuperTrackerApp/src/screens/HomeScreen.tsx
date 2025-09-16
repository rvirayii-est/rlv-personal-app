import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import type { DrawerNavigationProp } from '@react-navigation/drawer';
import type { DrawerParamList } from '../types/navigation';
import Icon from 'react-native-vector-icons/MaterialIcons';
import type { HomeScreenProps } from '../types/navigation';

const HomeScreen: React.FC<HomeScreenProps> = () => {
  const navigation = useNavigation<DrawerNavigationProp<DrawerParamList>>();

  const openDrawer = () => {
    navigation.openDrawer();
  };

  return (
    <View style={styles.container}>
      {/* Custom Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>SuperTracker Home</Text>
        <TouchableOpacity style={styles.drawerButton} onPress={openDrawer}>
          <Icon name="menu" size={24} color="#fff" />
        </TouchableOpacity>
      </View>

      {/* Content */}
      <ScrollView style={styles.content} contentContainerStyle={styles.contentContainer}>
        <View style={styles.welcomeCard}>
          <Icon name="dashboard" size={48} color="#2196F3" />
          <Text style={styles.welcomeTitle}>Welcome to SuperTracker!</Text>
          <Text style={styles.welcomeSubtitle}>
            Your personal tracking app is ready to use
          </Text>
        </View>

        {/* Quick Actions */}
        <View style={styles.quickActions}>
          <Text style={styles.sectionTitle}>Quick Actions</Text>
          
          <View style={styles.actionGrid}>
            <TouchableOpacity style={styles.actionCard}>
              <Icon name="add" size={32} color="#4CAF50" />
              <Text style={styles.actionText}>Add Entry</Text>
            </TouchableOpacity>
            
            <TouchableOpacity style={styles.actionCard}>
              <Icon name="analytics" size={32} color="#FF9800" />
              <Text style={styles.actionText}>View Stats</Text>
            </TouchableOpacity>
            
            <TouchableOpacity style={styles.actionCard}>
              <Icon name="history" size={32} color="#9C27B0" />
              <Text style={styles.actionText}>History</Text>
            </TouchableOpacity>
            
            <TouchableOpacity style={styles.actionCard}>
              <Icon name="settings" size={32} color="#607D8B" />
              <Text style={styles.actionText}>Settings</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Recent Activity */}
        <View style={styles.recentActivity}>
          <Text style={styles.sectionTitle}>Recent Activity</Text>
          <View style={styles.activityCard}>
            <Text style={styles.activityText}>No recent activity</Text>
            <Text style={styles.activitySubtext}>Start tracking to see your activity here</Text>
          </View>
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
  welcomeCard: {
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
  welcomeTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginTop: 16,
    marginBottom: 8,
  },
  welcomeSubtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
  },
  quickActions: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 16,
  },
  actionGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  actionCard: {
    backgroundColor: '#fff',
    width: '48%',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    marginBottom: 12,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  actionText: {
    fontSize: 14,
    fontWeight: '500',
    color: '#333',
    marginTop: 8,
  },
  recentActivity: {
    marginBottom: 24,
  },
  activityCard: {
    backgroundColor: '#fff',
    padding: 20,
    borderRadius: 12,
    alignItems: 'center',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  activityText: {
    fontSize: 16,
    color: '#333',
    marginBottom: 4,
  },
  activitySubtext: {
    fontSize: 14,
    color: '#666',
  },
});

export default HomeScreen;