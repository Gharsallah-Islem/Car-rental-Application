import { NavigationContainer } from "@react-navigation/native";
import { useAuthStore } from "../store/authStore";
import AuthNavigator from "./AuthNavigator";
import PatientNavigator from "./PatientNavigator";
import PharmacienNavigator from "./PharmacienNavigator";

export default function AppNavigator() {
  const { user, isAuthenticated } = useAuthStore();

  if (!isAuthenticated || !user) {
    return (
      <NavigationContainer>
        <AuthNavigator />
      </NavigationContainer>
    );
  }

  // Route based on user role
  if (user.role === "patient") {
    return (
      <NavigationContainer>
        <PatientNavigator />
      </NavigationContainer>
    );
  }

  if (user.role === "pharmacien") {
    return (
      <NavigationContainer>
        <PharmacienNavigator />
      </NavigationContainer>
    );
  }

  // Fallback to auth if role is not recognized
  return (
    <NavigationContainer>
      <AuthNavigator />
    </NavigationContainer>
  );
}
