import React from 'react';
import { createDrawerNavigator } from '@react-navigation/drawer';
import TabNavigator from './TabNavigator'; // The tabs we just made
import SettingsScreen from '../screens/SettingsScreen';

const Drawer = createDrawerNavigator();

const DrawerNavigator = () => {
  return (
    <Drawer.Navigator
      // This is the key prop to make the drawer open from the right
      screenOptions={{ drawerPosition: 'right' }}>
      <Drawer.Screen
        name="Main"
        component={TabNavigator} // Our TabNavigator is nested here
        options={{ title: 'Home' }}
      />
      <Drawer.Screen name="Settings" component={SettingsScreen} />
    </Drawer.Navigator>
  );
};

export default DrawerNavigator;