import { useEffect } from "react";
import { Alert, FlatList, StyleSheet, Text, View } from "react-native";
import Button from "../../components/common/Button";
import LoadingSpinner from "../../components/common/LoadingSpinner";
import MedicamentItem from "../../components/pharmacien/MedicamentItem";
import { useMedicamentStore } from "../../store/medicamentStore";

export default function MedicamentListScreen({ navigation }) {
  const { medicaments, isLoading, loadMedicaments, deleteMedicament } = useMedicamentStore();

  useEffect(() => {
    loadMedicaments();
  }, [loadMedicaments]);

  // Refresh on focus
  useEffect(() => {
    const unsubscribe = navigation.addListener("focus", () => {
      loadMedicaments();
    });

    return unsubscribe;
  }, [navigation, loadMedicaments]);

  const handleDelete = (medicament) => {
    Alert.alert(
      "Confirmer la suppression",
      `Êtes-vous sûr de vouloir supprimer ${medicament.nom}?`,
      [
        { text: "Annuler", style: "cancel" },
        {
          text: "Supprimer",
          style: "destructive",
          onPress: async () => {
            await deleteMedicament(medicament.id);
          },
        },
      ]
    );
  };

  if (isLoading) {
    return <LoadingSpinner />;
  }

  return (
    <View style={styles.container}>
      <View style={styles.headerContainer}>
        <Button
          title="+ Nouveau médicament"
          onPress={() => navigation.navigate("MedicamentForm")}
          style={styles.addButton}
        />
      </View>

      {medicaments.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>Aucun médicament enregistré</Text>
          <Text style={styles.emptySubtext}>Ajoutez votre premier médicament</Text>
        </View>
      ) : (
        <FlatList
          data={medicaments}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <MedicamentItem
              medicament={item}
              onEdit={() => navigation.navigate("MedicamentForm", { medicament: item })}
              onDelete={() => handleDelete(item)}
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
    backgroundColor: "#f5f5f5",
  },
  headerContainer: {
    padding: 16,
    backgroundColor: "#fff",
    borderBottomWidth: 1,
    borderBottomColor: "#e0e0e0",
  },
  addButton: {
    marginBottom: 0,
  },
  list: {
    padding: 16,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 24,
  },
  emptyText: {
    fontSize: 18,
    fontWeight: "600",
    color: "#666",
    textAlign: "center",
    marginBottom: 8,
  },
  emptySubtext: {
    fontSize: 14,
    color: "#999",
    textAlign: "center",
  },
});
