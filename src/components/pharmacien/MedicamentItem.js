import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import Card from "../common/Card";

export default function MedicamentItem({ medicament, onEdit, onDelete }) {
  return (
    <Card>
      <View style={styles.header}>
        <Text style={styles.nom}>{medicament.nom}</Text>
      </View>
      <View style={styles.row}>
        <Text style={styles.label}>Dosage:</Text>
        <Text style={styles.value}>{medicament.dosage}</Text>
      </View>
      <View style={styles.row}>
        <Text style={styles.label}>Forme:</Text>
        <Text style={styles.value}>{medicament.forme}</Text>
      </View>
      <View style={styles.row}>
        <Text style={styles.label}>Stock:</Text>
        <Text style={[styles.value, medicament.quantiteStock < 10 && styles.lowStock]}>
          {medicament.quantiteStock}
        </Text>
      </View>
      <View style={styles.actions}>
        <TouchableOpacity onPress={onEdit} style={styles.actionButton}>
          <Text style={styles.editText}>Modifier</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={onDelete} style={styles.actionButton}>
          <Text style={styles.deleteText}>Supprimer</Text>
        </TouchableOpacity>
      </View>
    </Card>
  );
}

const styles = StyleSheet.create({
  header: {
    marginBottom: 14,
  },
  nom: {
    fontSize: 20,
    fontWeight: "700",
    color: "#1a1a1a",
  },
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 10,
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
  lowStock: {
    color: "#FF3B30",
    fontWeight: "700",
  },
  actions: {
    flexDirection: "row",
    marginTop: 16,
    gap: 12,
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: "#f0f0f0",
  },
  actionButton: {
    flex: 1,
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: "center",
    backgroundColor: "#f8f9fa",
  },
  editText: {
    color: "#007AFF",
    fontWeight: "700",
    fontSize: 15,
  },
  deleteText: {
    color: "#FF3B30",
    fontWeight: "700",
    fontSize: 15,
  },
});
