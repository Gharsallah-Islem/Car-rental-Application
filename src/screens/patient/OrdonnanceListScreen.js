import { useEffect } from "react";
import { FlatList, StyleSheet, Text, TouchableOpacity, View } from "react-native";
import LoadingSpinner from "../../components/common/LoadingSpinner";
import OrdonnanceItem from "../../components/patient/OrdonnanceItem";
import { useAuthStore } from "../../store/authStore";
import { useOrdonnanceStore } from "../../store/ordonnanceStore";

export default function OrdonnanceListScreen({ navigation }) {
  const { ordonnances, isLoading, loadOrdonnancesByPatient } = useOrdonnanceStore();
  const { user, logout } = useAuthStore();

  useEffect(() => {
    if (user) {
      loadOrdonnancesByPatient(user.id);
    }
  }, [user, loadOrdonnancesByPatient]);

  const handleLogout = () => {
    logout();
  };

  if (isLoading) {
    return <LoadingSpinner />;
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>Bonjour,</Text>
          <Text style={styles.userName}>{user?.name || 'Patient'}</Text>
        </View>
        <TouchableOpacity onPress={handleLogout} style={styles.logoutButton}>
          <Text style={styles.logoutText}>Déconnexion</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.titleContainer}>
        <Text style={styles.title}>📋 Mes Ordonnances</Text>
        <Text style={styles.subtitle}>Consultez et gérez vos ordonnances</Text>
      </View>

      {ordonnances.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>Aucune ordonnance disponible</Text>
        </View>
      ) : (
        <FlatList
          data={ordonnances}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <OrdonnanceItem
              ordonnance={item}
              onPress={() => navigation.navigate("OrdonnanceDetail", { ordonnance: item })}
            />
          )}
          contentContainerStyle={styles.list}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f8f9fa",
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingHorizontal: 20,
    paddingTop: 60,
    paddingBottom: 20,
    backgroundColor: "#007AFF",
  },
  greeting: {
    fontSize: 14,
    color: "rgba(255,255,255,0.9)",
    fontWeight: "500",
  },
  userName: {
    fontSize: 22,
    fontWeight: "700",
    color: "#fff",
    marginTop: 2,
  },
  logoutButton: {
    backgroundColor: "rgba(255,255,255,0.2)",
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
  },
  logoutText: {
    color: "#fff",
    fontSize: 14,
    fontWeight: "600",
  },
  titleContainer: {
    backgroundColor: "#fff",
    padding: 20,
    borderBottomLeftRadius: 24,
    borderBottomRightRadius: 24,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
    marginBottom: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: "700",
    color: "#1a1a1a",
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 14,
    color: "#666",
    fontWeight: "400",
  },
  list: {
    paddingHorizontal: 20,
    paddingBottom: 20,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 40,
  },
  emptyText: {
    fontSize: 18,
    color: "#999",
    textAlign: "center",
    fontWeight: "500",
  },
});
