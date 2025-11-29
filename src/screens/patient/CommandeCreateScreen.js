import { useState } from "react";
import { Alert, ScrollView, StyleSheet } from "react-native";
import Button from "../../components/common/Button";
import Card from "../../components/common/Card";
import Input from "../../components/common/Input";
import { useAuthStore } from "../../store/authStore";
import { useCommandeStore } from "../../store/commandeStore";

// Mock pharmacies data
const PHARMACIES = [
  { id: "ph001", name: "Pharmacie Centrale", adresse: "12 Avenue principale" },
  { id: "ph002", name: "Pharmacie du Centre", adresse: "45 Rue de la Paix" },
  { id: "ph003", name: "Pharmacie de la Gare", adresse: "78 Boulevard Gare" },
];

export default function CommandeCreateScreen({ route, navigation }) {
  const { ordonnance } = route.params;
  const { addCommande } = useCommandeStore();
  const { user } = useAuthStore();

  const [selectedPharmacy, setSelectedPharmacy] = useState(null);
  const [lieuLivraison, setLieuLivraison] = useState("");
  const [remarques, setRemarques] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleCreateCommande = async () => {
    if (!selectedPharmacy) {
      Alert.alert("Erreur", "Veuillez sélectionner une pharmacie");
      return;
    }

    if (!lieuLivraison.trim()) {
      Alert.alert("Erreur", "Veuillez indiquer le lieu de livraison");
      return;
    }

    setIsSubmitting(true);

    const newCommande = {
      id: `cmd_${Date.now()}`,
      ordonnanceId: ordonnance.id,
      patientId: user.id,
      pharmacienId: selectedPharmacy.id,
      status: "en_attente",
      dateCreation: new Date().toISOString(),
      lieuLivraison: lieuLivraison.trim(),
      remarques: remarques.trim(),
    };

    try {
      await addCommande(newCommande);
      Alert.alert(
        "Succès",
        "Votre commande a été créée avec succès",
        [
          {
            text: "OK",
            onPress: () => navigation.navigate("CommandeList"),
          },
        ]
      );
    } catch (_error) {
      Alert.alert("Erreur", "Impossible de créer la commande");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Card title="Sélectionner une pharmacie">
        {PHARMACIES.map((pharmacy) => (
          <Button
            key={pharmacy.id}
            title={`${pharmacy.name}\n${pharmacy.adresse}`}
            variant={selectedPharmacy?.id === pharmacy.id ? "primary" : "secondary"}
            onPress={() => setSelectedPharmacy(pharmacy)}
            style={styles.pharmacyButton}
          />
        ))}
      </Card>

      <Card title="Informations de livraison">
        <Input
          label="Lieu de livraison *"
          value={lieuLivraison}
          onChangeText={setLieuLivraison}
          placeholder="Adresse de livraison"
        />

        <Input
          label="Remarques (optionnel)"
          value={remarques}
          onChangeText={setRemarques}
          placeholder="Instructions spéciales..."
          multiline
        />
      </Card>

      <Button
        title="Confirmer la commande"
        onPress={handleCreateCommande}
        loading={isSubmitting}
        disabled={!selectedPharmacy || !lieuLivraison.trim()}
        style={styles.submitButton}
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
  pharmacyButton: {
    marginBottom: 14,
    height: "auto",
    paddingVertical: 16,
  },
  submitButton: {
    marginTop: 12,
  },
});
