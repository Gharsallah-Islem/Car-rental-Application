import { useState } from "react";
import {
    Alert,
    KeyboardAvoidingView,
    Platform,
    ScrollView,
    StyleSheet,
    Text,
    View,
} from "react-native";
import Button from "../../components/common/Button";
import Input from "../../components/common/Input";
import { useAuthStore } from "../../store/authStore";

export default function LoginScreen({ navigation }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const { login, isLoading, error } = useAuthStore();

  const handleLogin = async () => {
    if (!email || !password) {
      Alert.alert("Erreur", "Veuillez remplir tous les champs");
      return;
    }

    const success = await login(email, password);
    if (success) {
      // Navigation will be handled by AppNavigator based on auth state
    } else {
      Alert.alert("Erreur", error || "Email ou mot de passe incorrect");
    }
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      style={styles.container}
    >
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <View style={styles.content}>
          <Text style={styles.title}>Gestion d&apos;Ordonnances</Text>
          <Text style={styles.subtitle}>Connectez-vous à votre compte</Text>

          <View style={styles.form}>
            <Input
              label="Email"
              value={email}
              onChangeText={setEmail}
              placeholder="exemple@email.com"
              keyboardType="email-address"
              autoCapitalize="none"
            />

            <Input
              label="Mot de passe"
              value={password}
              onChangeText={setPassword}
              placeholder="Votre mot de passe"
              secureTextEntry
            />

            <Button
              title="Se connecter"
              onPress={handleLogin}
              loading={isLoading}
              style={styles.button}
            />
          </View>

          <View style={styles.infoBox}>
            <Text style={styles.infoTitle}>Comptes de test:</Text>
            <Text style={styles.infoText}>Patient: patient@test.com / patient123</Text>
            <Text style={styles.infoText}>Pharmacien: pharmacien@test.com / pharma123</Text>
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f8f9fa",
  },
  scrollContent: {
    flexGrow: 1,
  },
  content: {
    flex: 1,
    justifyContent: "center",
    padding: 24,
  },
  title: {
    fontSize: 32,
    fontWeight: "800",
    color: "#007AFF",
    textAlign: "center",
    marginBottom: 8,
    letterSpacing: -0.5,
  },
  subtitle: {
    fontSize: 16,
    color: "#666",
    textAlign: "center",
    marginBottom: 50,
    fontWeight: "500",
  },
  form: {
    marginBottom: 24,
  },
  button: {
    marginTop: 12,
  },
  infoBox: {
    backgroundColor: "#E3F2FD",
    padding: 20,
    borderRadius: 16,
    marginTop: 20,
    borderWidth: 1,
    borderColor: "rgba(25, 118, 210, 0.1)",
  },
  infoTitle: {
    fontSize: 15,
    fontWeight: "700",
    color: "#1976D2",
    marginBottom: 12,
  },
  infoText: {
    fontSize: 13,
    color: "#1565C0",
    marginBottom: 6,
    fontWeight: "500",
  },
});
