import type { NavigatorScreenParams } from '@react-navigation/native';
import type { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import type { DrawerScreenProps } from '@react-navigation/drawer';

// Tab Navigator Param List
export type TabParamList = {
  Home: undefined;
  Feed: undefined;
  Profile: undefined;
};

// Drawer Navigator Param List
export type DrawerParamList = {
  Main: NavigatorScreenParams<TabParamList>;
  Settings: undefined;
};

// Screen Props Types
export type TabScreenProps<T extends keyof TabParamList> = BottomTabScreenProps<TabParamList, T>;
export type DrawerScreenPropsType<T extends keyof DrawerParamList> = DrawerScreenProps<DrawerParamList, T>;

// Navigation Props
export type HomeScreenProps = TabScreenProps<'Home'>;
export type FeedScreenProps = TabScreenProps<'Feed'>;
export type ProfileScreenProps = TabScreenProps<'Profile'>;
export type SettingsScreenProps = DrawerScreenPropsType<'Settings'>;
