import { saveItem } from "../api/asyncStorage";

export const seedDatabase = async () => {
  // Sample Users
  const users = [
    {
      id: "u001",
      role: "patient",
      name: "Jean Martin",
      email: "patient@test.com",
      password: "patient123",
    },
    {
      id: "u002",
      role: "pharmacien",
      name: "Marie Dubois",
      email: "pharmacien@test.com",
      password: "pharma123",
    },
    {
      id: "u003",
      role: "medecin",
      name: "Dr. Pierre Durant",
      email: "medecin@test.com",
      password: "medecin123",
    },
  ];

  // Sample Patients
  const patients = [
    {
      id: "u001",
      name: "Jean Martin",
      age: 45,
      adresse: "10 rue des Lilas, Paris",
      telephone: "0601020304",
    },
  ];

  // Sample Medicaments
  const medicaments = [
    {
      id: "m001",
      nom: "Doliprane",
      dosage: "500 mg",
      forme: "Comprimé",
      quantiteStock: 120,
    },
    {
      id: "m002",
      nom: "Ibuprofène",
      dosage: "400 mg",
      forme: "Comprimé",
      quantiteStock: 80,
    },
    {
      id: "m003",
      nom: "Amoxicilline",
      dosage: "1 g",
      forme: "Gélule",
      quantiteStock: 45,
    },
    {
      id: "m004",
      nom: "Ventoline",
      dosage: "100 μg",
      forme: "Spray",
      quantiteStock: 30,
    },
  ];

  // Sample Ordonnances
  const ordonnances = [
    {
      id: "o001",
      patientId: "u001",
      medecinId: "u003",
      medicaments: [
        {
          idMedicament: "m001",
          quantiteParJour: 3,
          duree: 5,
        },
        {
          idMedicament: "m002",
          quantiteParJour: 2,
          duree: 7,
        },
      ],
      date: "2025-01-15",
    },
    {
      id: "o002",
      patientId: "u001",
      medecinId: "u003",
      medicaments: [
        {
          idMedicament: "m003",
          quantiteParJour: 2,
          duree: 10,
        },
      ],
      date: "2025-01-20",
    },
  ];

  // Sample Commandes
  const commandes = [
    {
      id: "cmd001",
      ordonnanceId: "o001",
      patientId: "u001",
      pharmacienId: "u002",
      status: "en_preparation",
      dateCreation: "2025-01-16T10:30:00Z",
      lieuLivraison: "10 rue des Lilas, Paris",
      remarques: "Livraison avant 18h si possible",
    },
  ];

  // Save all data
  await saveItem("users", users);
  await saveItem("patients", patients);
  await saveItem("medicaments", medicaments);
  await saveItem("ordonnances", ordonnances);
  await saveItem("commandes", commandes);

  console.log("✅ Base de données initialisée avec succès!");
};
