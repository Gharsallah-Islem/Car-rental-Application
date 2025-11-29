import { StyleSheet, Text, TextInput, View } from "react-native";

export default function Input({ 
  label, 
  value, 
  onChangeText, 
  placeholder, 
  secureTextEntry = false,
  keyboardType = "default",
  multiline = false,
  error,
  style 
}) {
  return (
    <View style={[styles.container, style]}>
      {label && <Text style={styles.label}>{label}</Text>}
      <TextInput
        style={[styles.input, multiline && styles.inputMultiline, error && styles.inputError]}
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        secureTextEntry={secureTextEntry}
        keyboardType={keyboardType}
        multiline={multiline}
        placeholderTextColor="#999"
      />
      {error && <Text style={styles.errorText}>{error}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginBottom: 20,
  },
  label: {
    fontSize: 15,
    fontWeight: "600",
    color: "#1a1a1a",
    marginBottom: 8,
  },
  input: {
    borderWidth: 1.5,
    borderColor: "#e0e0e0",
    borderRadius: 12,
    paddingVertical: 14,
    paddingHorizontal: 16,
    fontSize: 16,
    backgroundColor: "#fff",
    color: "#1a1a1a",
  },
  inputMultiline: {
    minHeight: 100,
    textAlignVertical: "top",
    paddingTop: 14,
  },
  inputError: {
    borderColor: "#FF3B30",
    borderWidth: 2,
  },
  errorText: {
    color: "#FF3B30",
    fontSize: 13,
    marginTop: 6,
    fontWeight: "500",
  },
});
