import { useEffect, useState } from "react";
import { ScrollView, StyleSheet, Text, View } from "react-native";
import Button from "../../components/common/Button";
import Card from "../../components/common/Card";
import { useMedicamentStore } from "../../store/medicamentStore";

export default function OrdonnanceDetailScreen({ route, navigation }) {
  const { ordonnance } = route.params;
  const { medicaments, loadMedicaments } = useMedicamentStore();
  const [medicamentDetails, setMedicamentDetails] = useState([]);

  useEffect(() => {
    loadMedicaments();
  }, [loadMedicaments]);

  useEffect(() => {
    if (medicaments.length > 0 && ordonnance.medicaments) {
      const details = ordonnance.medicaments.map((med) => {
        const medicament = medicaments.find((m) => m.id === med.idMedicament);
        return {
          ...med,
          ...medicament,
        };
      });
      setMedicamentDetails(details);
    }
  }, [medicaments, ordonnance]);

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString("fr-FR");
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Card title="Informations">
        <View style={styles.row}>
          <Text style={styles.label}>Date:</Text>
          <Text style={styles.value}>{formatDate(ordonnance.date)}</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>ID Ordonnance:</Text>
          <Text style={styles.value}>#{ordonnance.id}</Text>
        </View>
      </Card>

      <Card title="Médicaments prescrits">
        {medicamentDetails.length === 0 ? (
          <Text style={styles.emptyText}>Chargement...</Text>
        ) : (
          medicamentDetails.map((med, index) => (
            <View key={index} style={styles.medicamentItem}>
              <Text style={styles.medName}>{med.nom || "Médicament inconnu"}</Text>
              <Text style={styles.medDetail}>
                {med.dosage} - {med.forme}
              </Text>
              <Text style={styles.medPosology}>
                {med.quantiteParJour} fois/jour pendant {med.duree} jours
              </Text>
              {index < medicamentDetails.length - 1 && <View style={styles.separator} />}
            </View>
          ))
        )}
      </Card>

      <Button
        title="Créer une commande"
        onPress={() => navigation.navigate("CommandeCreate", { ordonnance })}
        style={styles.button}
      />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f8f9fa",
  },
  content: {
    padding: 20,
  },
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 14,
  },
  label: {
    fontSize: 15,
    color: "#666",
    fontWeight: "500",
  },
  value: {
    fontSize: 15,
    color: "#1a1a1a",
    fontWeight: "700",
  },
  medicamentItem: {
    marginBottom: 20,
    paddingBottom: 16,
  },
  medName: {
    fontSize: 18,
    fontWeight: "700",
    color: "#1a1a1a",
    marginBottom: 6,
  },
  medDetail: {
    fontSize: 15,
    color: "#666",
    marginBottom: 6,
  },
  medPosology: {
    fontSize: 15,
    color: "#007AFF",
    fontWeight: "600",
    marginTop: 4,
  },
  separator: {
    height: 1,
    backgroundColor: "#f0f0f0",
    marginTop: 16,
  },
  emptyText: {
    fontSize: 15,
    color: "#999",
    textAlign: "center",
    fontStyle: "italic",
  },
  button: {
    marginTop: 12,
  },
});
