import { useEffect, useState } from "react";
import { ActivityIndicator, StyleSheet, Text, View } from "react-native";
import { getItem } from "./src/api/asyncStorage";
import { seedDatabase } from "./src/data/seedData";
import AppNavigator from "./src/navigation/AppNavigator";

export default function App() {
  const [isInitialized, setIsInitialized] = useState(false);

  useEffect(() => {
    initializeApp();
  }, []);

  const initializeApp = async () => {
    try {
      // Check if database is already seeded
      const users = await getItem("users");
      
      if (!users || users.length === 0) {
        console.log("Initializing database with sample data...");
        await seedDatabase();
      } else {
        console.log("Database already initialized");
      }
      
      setIsInitialized(true);
    } catch (error) {
      console.error("Error initializing app:", error);
      setIsInitialized(true); // Continue anyway
    }
  };

  if (!isInitialized) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#007AFF" />
        <Text style={styles.loadingText}>Chargement...</Text>
      </View>
    );
  }

  return <AppNavigator />;
}

const styles = StyleSheet.create({
  loadingContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#f5f5f5",
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: "#666",
  },
});
