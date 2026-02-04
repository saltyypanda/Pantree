// app/(tabs)/_layout.tsx
import { Tabs } from "expo-router";
import { Platform } from "react-native";

export default function TabsLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false, // we'll typically show headers inside each tab's own stack/layout
        tabBarHideOnKeyboard: Platform.OS === "android",
      }}
    >
      <Tabs.Screen
        name="recipes"
        options={{
          title: "Recipes",
          // tabBarIcon: ({ color, size }) => <YourIcon name="book" color={color} size={size} />,
        }}
      />

      <Tabs.Screen
        name="pantry"
        options={{
          title: "Pantry",
          // tabBarIcon: ({ color, size }) => <YourIcon name="basket" color={color} size={size} />,
        }}
      />
    </Tabs>
  );
}
