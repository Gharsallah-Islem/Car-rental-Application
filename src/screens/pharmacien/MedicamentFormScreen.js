import { useState } from "react";
import { Alert, KeyboardAvoidingView, Platform, ScrollView, StyleSheet, View } from "react-native";
import Button from "../../components/common/Button";
import Card from "../../components/common/Card";
import Input from "../../components/common/Input";
import { useMedicamentStore } from "../../store/medicamentStore";

export default function MedicamentFormScreen({ route, navigation }) {
  const existingMedicament = route.params?.medicament;
  const isEditing = !!existingMedicament;

  const { addMedicament, updateMedicament } = useMedicamentStore();

  const [nom, setNom] = useState(existingMedicament?.nom || "");
  const [dosage, setDosage] = useState(existingMedicament?.dosage || "");
  const [forme, setForme] = useState(existingMedicament?.forme || "");
  const [quantiteStock, setQuantiteStock] = useState(
    existingMedicament?.quantiteStock?.toString() || ""
  );
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async () => {
    // Validation
    if (!nom.trim()) {
      Alert.alert("Erreur", "Le nom du médicament est requis");
      return;
    }
    if (!dosage.trim()) {
      Alert.alert("Erreur", "Le dosage est requis");
      return;
    }
    if (!forme.trim()) {
      Alert.alert("Erreur", "La forme est requise");
      return;
    }
    if (!quantiteStock.trim() || isNaN(Number(quantiteStock))) {
      Alert.alert("Erreur", "La quantité en stock doit être un nombre");
      return;
    }

    setIsSubmitting(true);

    try {
      if (isEditing) {
        await updateMedicament(existingMedicament.id, {
          nom: nom.trim(),
          dosage: dosage.trim(),
          forme: forme.trim(),
          quantiteStock: parseInt(quantiteStock),
        });
        Alert.alert("Succès", "Médicament mis à jour avec succès", [
          {
            text: "OK",
            onPress: () => navigation.goBack(),
          },
        ]);
      } else {
        const newMedicament = {
          id: `med_${Date.now()}`,
          nom: nom.trim(),
          dosage: dosage.trim(),
          forme: forme.trim(),
          quantiteStock: parseInt(quantiteStock),
        };
        await addMedicament(newMedicament);
        Alert.alert("Succès", "Médicament ajouté avec succès", [
          {
            text: "OK",
            onPress: () => navigation.goBack(),
          },
        ]);
      }
    } catch (_error) {
      Alert.alert("Erreur", "Impossible de sauvegarder le médicament");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      style={styles.container}
    >
      <ScrollView contentContainerStyle={styles.content}>
        <Card title={isEditing ? "Modifier le médicament" : "Nouveau médicament"}>
          <Input
            label="Nom du médicament *"
            value={nom}
            onChangeText={setNom}
            placeholder="Ex: Doliprane"
          />

          <Input
            label="Dosage *"
            value={dosage}
            onChangeText={setDosage}
            placeholder="Ex: 500 mg"
          />

          <Input
            label="Forme *"
            value={forme}
            onChangeText={setForme}
            placeholder="Ex: Comprimé"
          />

          <Input
            label="Quantité en stock *"
            value={quantiteStock}
            onChangeText={setQuantiteStock}
            placeholder="Ex: 100"
            keyboardType="numeric"
          />

          <View style={styles.buttonContainer}>
            <Button
              title={isEditing ? "Mettre à jour" : "Ajouter"}
              onPress={handleSubmit}
              loading={isSubmitting}
              style={styles.submitButton}
            />
            <Button
              title="Annuler"
              variant="secondary"
              onPress={() => navigation.goBack()}
              style={styles.cancelButton}
            />
          </View>
        </Card>
      </ScrollView>
    </KeyboardAvoidingView>
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
  buttonContainer: {
    marginTop: 8,
  },
  submitButton: {
    marginBottom: 12,
  },
  cancelButton: {
    marginBottom: 0,
  },
});
