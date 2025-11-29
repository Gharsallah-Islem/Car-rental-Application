import { ScrollView, StyleSheet, Text, View } from "react-native";
import Card from "../../components/common/Card";
import CommandeStatusBadge from "../../components/pharmacien/CommandeStatusBadge";

export default function CommandeDetailScreen({ route }) {
  const { commande } = route.params;

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

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Card title="Statut de la commande">
        <CommandeStatusBadge status={commande.status} />
      </Card>

      <Card title="Informations">
        <View style={styles.row}>
          <Text style={styles.label}>N° Commande:</Text>
          <Text style={styles.value}>#{commande.id}</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>Date de création:</Text>
          <Text style={styles.value}>{formatDate(commande.dateCreation)}</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>N° Ordonnance:</Text>
          <Text style={styles.value}>#{commande.ordonnanceId}</Text>
        </View>
      </Card>

      {commande.lieuLivraison && (
        <Card title="Livraison">
          <Text style={styles.address}>{commande.lieuLivraison}</Text>
        </Card>
      )}

      {commande.remarques && (
        <Card title="Remarques">
          <Text style={styles.remarques}>{commande.remarques}</Text>
        </Card>
      )}

      <View style={styles.infoBox}>
        <Text style={styles.infoText}>
          Vous serez notifié lorsque votre commande sera prête pour le retrait.
        </Text>
      </View>
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
  address: {
    fontSize: 15,
    color: "#1a1a1a",
    lineHeight: 22,
    fontWeight: "500",
  },
  remarques: {
    fontSize: 15,
    color: "#666",
    lineHeight: 22,
    fontStyle: "italic",
  },
  infoBox: {
    backgroundColor: "#E8F5E9",
    padding: 18,
    borderRadius: 12,
    marginTop: 12,
    borderWidth: 1,
    borderColor: "rgba(76, 175, 80, 0.2)",
  },
  infoText: {
    fontSize: 14,
    color: "#2E7D32",
    textAlign: "center",
    lineHeight: 20,
    fontWeight: "500",
  },
});
