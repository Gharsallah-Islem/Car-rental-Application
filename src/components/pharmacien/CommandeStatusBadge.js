import { StyleSheet, Text, View } from "react-native";

const STATUS_LABELS = {
  en_attente: "En attente",
  en_preparation: "En préparation",
  prete: "Prête",
};

const STATUS_COLORS = {
  en_attente: "#FF9500",
  en_preparation: "#007AFF",
  prete: "#34C759",
};

export default function CommandeStatusBadge({ status }) {
  return (
    <View style={[styles.badge, { backgroundColor: STATUS_COLORS[status] }]}>
      <Text style={styles.text}>{STATUS_LABELS[status]}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  badge: {
    paddingHorizontal: 18,
    paddingVertical: 10,
    borderRadius: 20,
    alignSelf: "flex-start",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 3,
  },
  text: {
    color: "#fff",
    fontSize: 15,
    fontWeight: "700",
    letterSpacing: 0.5,
  },
});
