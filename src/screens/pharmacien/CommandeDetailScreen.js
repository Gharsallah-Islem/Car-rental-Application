import { useState } from "react";
import { Alert, ScrollView, StyleSheet, Text, View } from "react-native";
import Button from "../../components/common/Button";
import Card from "../../components/common/Card";
import CommandeStatusBadge from "../../components/pharmacien/CommandeStatusBadge";
import { useCommandeStore } from "../../store/commandeStore";

const STATUS_OPTIONS = [
  { value: "en_attente", label: "En attente", color: "#FF9500" },
  { value: "en_preparation", label: "En préparation", color: "#007AFF" },
  { value: "prete", label: "Prête", color: "#34C759" },
];

export default function PharmacienCommandeDetailScreen({ route, navigation }) {
  const { commande } = route.params;
  const { updateCommandeStatus } = useCommandeStore();
  const [isUpdating, setIsUpdating] = useState(false);

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString("fr-FR", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const handleStatusChange = async (newStatus) => {
    if (newStatus === commande.status) return;

    setIsUpdating(true);
    try {
      await updateCommandeStatus(commande.id, newStatus);
      Alert.alert(
        "Succès",
        "Le statut de la commande a été mis à jour",
        [
          {
            text: "OK",
            onPress: () => navigation.goBack(),
          },
        ]
      );
    } catch (_error) {
      Alert.alert("Erreur", "Impossible de mettre à jour le statut");
    } finally {
      setIsUpdating(false);
    }
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Card title="Statut actuel">
        <CommandeStatusBadge status={commande.status} />
      </Card>

      <Card title="Modifier le statut">
        {STATUS_OPTIONS.map((option) => (
          <Button
            key={option.value}
            title={option.label}
            variant={commande.status === option.value ? "primary" : "secondary"}
            onPress={() => handleStatusChange(option.value)}
            disabled={isUpdating}
            style={styles.statusButton}
          />
        ))}
      </Card>

      <Card title="Informations de la commande">
        <View style={styles.row}>
          <Text style={styles.label}>N° Commande:</Text>
          <Text style={styles.value}>#{commande.id}</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>N° Ordonnance:</Text>
          <Text style={styles.value}>#{commande.ordonnanceId}</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>Date de création:</Text>
          <Text style={styles.value}>{formatDate(commande.dateCreation)}</Text>
        </View>
      </Card>

      {commande.lieuLivraison && (
        <Card title="Adresse de livraison">
          <Text style={styles.address}>{commande.lieuLivraison}</Text>
        </Card>
      )}

      {commande.remarques && (
        <Card title="Remarques du patient">
          <Text style={styles.remarques}>{commande.remarques}</Text>
        </Card>
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  content: {
    padding: 16,
  },
  statusButton: {
    marginBottom: 12,
  },
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 12,
  },
  label: {
    fontSize: 14,
    color: "#666",
    fontWeight: "500",
  },
  value: {
    fontSize: 14,
    color: "#333",
    fontWeight: "600",
  },
  address: {
    fontSize: 14,
    color: "#333",
    lineHeight: 20,
  },
  remarques: {
    fontSize: 14,
    color: "#666",
    lineHeight: 20,
    fontStyle: "italic",
  },
});
