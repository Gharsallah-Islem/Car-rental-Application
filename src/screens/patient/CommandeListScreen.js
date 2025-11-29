import { useEffect } from "react";
import { FlatList, StyleSheet, Text, View } from "react-native";
import LoadingSpinner from "../../components/common/LoadingSpinner";
import CommandeItem from "../../components/patient/CommandeItem";
import { useAuthStore } from "../../store/authStore";
import { useCommandeStore } from "../../store/commandeStore";

export default function CommandeListScreen({ navigation }) {
  const { commandes, isLoading, loadCommandesByPatient } = useCommandeStore();
  const { user } = useAuthStore();

  useEffect(() => {
    if (user) {
      loadCommandesByPatient(user.id);
    }
  }, [user, loadCommandesByPatient]);

  // Refresh on focus
  useEffect(() => {
    const unsubscribe = navigation.addListener("focus", () => {
      if (user) {
        loadCommandesByPatient(user.id);
      }
    });

    return unsubscribe;
  }, [navigation, user, loadCommandesByPatient]);

  if (isLoading) {
    return <LoadingSpinner />;
  }

  return (
    <View style={styles.container}>
      {commandes.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>Aucune commande en cours</Text>
          <Text style={styles.emptySubtext}>
            Créez une commande à partir d&apos;une ordonnance
          </Text>
        </View>
      ) : (
        <FlatList
          data={commandes}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <CommandeItem
              commande={item}
              onPress={() => navigation.navigate("CommandeDetail", { commande: item })}
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
  list: {
    paddingHorizontal: 20,
    paddingTop: 20,
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
    fontWeight: "700",
    color: "#666",
    textAlign: "center",
    marginBottom: 8,
  },
  emptySubtext: {
    fontSize: 15,
    color: "#999",
    textAlign: "center",
    lineHeight: 22,
  },
});
