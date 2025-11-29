import { ActivityIndicator, StyleSheet, Text, TouchableOpacity } from "react-native";

export default function Button({ title, onPress, variant = "primary", disabled = false, loading = false, style }) {
  const buttonStyle = [
    styles.button,
    variant === "secondary" && styles.buttonSecondary,
    variant === "danger" && styles.buttonDanger,
    disabled && styles.buttonDisabled,
    style,
  ];

  const textStyle = [
    styles.buttonText,
    variant === "secondary" && styles.buttonTextSecondary,
  ];

  return (
    <TouchableOpacity
      style={buttonStyle}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.7}
    >
      {loading ? (
        <ActivityIndicator color={variant === "secondary" ? "#007AFF" : "#fff"} />
      ) : (
        <Text style={textStyle}>{title}</Text>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    backgroundColor: "#007AFF",
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 12,
    alignItems: "center",
    justifyContent: "center",
    minHeight: 54,
    shadowColor: "#007AFF",
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 4,
  },
  buttonSecondary: {
    backgroundColor: "#fff",
    borderWidth: 2,
    borderColor: "#007AFF",
    shadowColor: "#000",
    shadowOpacity: 0.1,
  },
  buttonDanger: {
    backgroundColor: "#FF3B30",
    shadowColor: "#FF3B30",
  },
  buttonDisabled: {
    backgroundColor: "#e0e0e0",
    opacity: 0.6,
    shadowOpacity: 0,
  },
  buttonText: {
    color: "#fff",
    fontSize: 17,
    fontWeight: "700",
    letterSpacing: 0.5,
  },
  buttonTextSecondary: {
    color: "#007AFF",
  },
});
