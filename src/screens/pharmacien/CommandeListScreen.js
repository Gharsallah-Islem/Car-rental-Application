import { useEffect } from "react";
import { FlatList, StyleSheet, Text, TouchableOpacity, View } from "react-native";
import Card from "../../components/common/Card";
import LoadingSpinner from "../../components/common/LoadingSpinner";
import CommandeStatusBadge from "../../components/pharmacien/CommandeStatusBadge";
import { useAuthStore } from "../../store/authStore";
import { useCommandeStore } from "../../store/commandeStore";

export default function PharmacienCommandeListScreen({ navigation }) {
  const { commandes, isLoading, loadCommandesByPharmacien } = useCommandeStore();
  const { user, logout } = useAuthStore();

  useEffect(() => {
    if (user) {
      loadCommandesByPharmacien(user.id);
    }
  }, [user, loadCommandesByPharmacien]);

  // Refresh on focus
  useEffect(() => {
    const unsubscribe = navigation.addListener("focus", () => {
      if (user) {
        loadCommandesByPharmacien(user.id);
      }
    });

    return unsubscribe;
  }, [navigation, user, loadCommandesByPharmacien]);

  const handleLogout = () => {
    logout();
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString("fr-FR");
  };

  if (isLoading) {
    return <LoadingSpinner />;
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>Bonjour,</Text>
          <Text style={styles.userName}>{user?.name || 'Pharmacien'}</Text>
        </View>
        <TouchableOpacity onPress={handleLogout} style={styles.logoutButton}>
          <Text style={styles.logoutText}>Déconnexion</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.titleContainer}>
        <Text style={styles.title}>📋 Commandes reçues</Text>
        <Text style={styles.subtitle}>Gérez les commandes de vos patients</Text>
      </View>

      {commandes.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>Aucune commande reçue</Text>
        </View>
      ) : (
        <FlatList
          data={commandes}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <Card onPress={() => navigation.navigate("PharmacienCommandeDetail", { commande: item })}>
              <View style={styles.cardHeader}>
                <Text style={styles.commandeId}>#{item.id}</Text>
                <CommandeStatusBadge status={item.status} />
              </View>
              <View style={styles.row}>
                <Text style={styles.label}>Date:</Text>
                <Text style={styles.value}>{formatDate(item.dateCreation)}</Text>
              </View>
              <View style={styles.row}>
                <Text style={styles.label}>Ordonnance:</Text>
                <Text style={styles.value}>#{item.ordonnanceId}</Text>
              </View>
              <Text style={styles.seeMore}>Gérer →</Text>
            </Card>
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
    backgroundColor: "#34C759",
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
  cardHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 12,
  },
  commandeId: {
    fontSize: 16,
    fontWeight: "700",
    color: "#333",
  },
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 8,
  },
  label: {
    fontSize: 14,
    color: "#666",
  },
  value: {
    fontSize: 14,
    color: "#333",
    fontWeight: "600",
  },
  seeMore: {
    color: "#007AFF",
    fontSize: 14,
    marginTop: 8,
    fontWeight: "600",
  },
  emptyContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 24,
  },
  emptyText: {
    fontSize: 16,
    color: "#999",
    textAlign: "center",
  },
});
