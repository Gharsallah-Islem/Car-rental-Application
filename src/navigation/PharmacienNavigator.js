import { Ionicons } from "@expo/vector-icons";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { createNativeStackNavigator } from "@react-navigation/native-stack";

import PharmacienCommandeDetailScreen from "../screens/pharmacien/CommandeDetailScreen";
import PharmacienCommandeListScreen from "../screens/pharmacien/CommandeListScreen";
import MedicamentFormScreen from "../screens/pharmacien/MedicamentFormScreen";
import MedicamentListScreen from "../screens/pharmacien/MedicamentListScreen";

const Tab = createBottomTabNavigator();
const CommandeStack = createNativeStackNavigator();
const MedicamentStack = createNativeStackNavigator();

function CommandeStackNavigator() {
  return (
    <CommandeStack.Navigator>
      <CommandeStack.Screen
        name="PharmacienCommandeList"
        component={PharmacienCommandeListScreen}
        options={{ headerShown: false }}
      />
      <CommandeStack.Screen
        name="PharmacienCommandeDetail"
        component={PharmacienCommandeDetailScreen}
        options={{ title: "Gérer la commande" }}
      />
    </CommandeStack.Navigator>
  );
}

function MedicamentStackNavigator() {
  return (
    <MedicamentStack.Navigator>
      <MedicamentStack.Screen
        name="MedicamentList"
        component={MedicamentListScreen}
        options={{ title: "Médicaments" }}
      />
      <MedicamentStack.Screen
        name="MedicamentForm"
        component={MedicamentFormScreen}
        options={({ route }) => ({
          title: route.params?.medicament ? "Modifier" : "Nouveau médicament",
        })}
      />
    </MedicamentStack.Navigator>
  );
}

export default function PharmacienNavigator() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;

          if (route.name === "CommandesTab") {
            iconName = focused ? "list" : "list-outline";
          } else if (route.name === "MedicamentsTab") {
            iconName = focused ? "medical" : "medical-outline";
          }

          return <Ionicons name={iconName} size={size + 2} color={color} />;
        },
        tabBarActiveTintColor: "#34C759",
        tabBarInactiveTintColor: "#8E8E93",
        headerShown: false,
        tabBarStyle: {
          height: 65,
          paddingBottom: 10,
          paddingTop: 10,
          backgroundColor: "#fff",
          borderTopWidth: 0,
          shadowColor: "#000",
          shadowOffset: { width: 0, height: -2 },
          shadowOpacity: 0.1,
          shadowRadius: 8,
          elevation: 10,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          fontWeight: "600",
        },
      })}
    >
      <Tab.Screen 
        name="CommandesTab" 
        component={CommandeStackNavigator}
        options={{ title: "Commandes" }}
      />
      <Tab.Screen 
        name="MedicamentsTab" 
        component={MedicamentStackNavigator}
        options={{ title: "Médicaments" }}
      />
    </Tab.Navigator>
  );
}
