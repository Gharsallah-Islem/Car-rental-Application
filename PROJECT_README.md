# 🏥 Gestion d'Ordonnances Médicales

Une application mobile React Native pour gérer les ordonnances médicales avec trois rôles : Médecin, Patient, et Pharmacien.

## 📱 Fonctionnalités implémentées

### Patient

- ✅ Consultation des ordonnances reçues
- ✅ Transformation d'une ordonnance en commande
- ✅ Choix d'une pharmacie
- ✅ Suivi de l'avancement des commandes (en attente → en préparation → prête)

### Pharmacien

- ✅ Gestion des médicaments (CRUD complet)
- ✅ Consultation des commandes
- ✅ Mise à jour du statut des commandes

### Authentification

- ✅ Login avec email/mot de passe
- ✅ Navigation basée sur le rôle utilisateur

## 🚀 Installation

### Prérequis

- Node.js (version 20.x)
- npm ou yarn
- Expo CLI
- Un émulateur Android/iOS ou l'app Expo Go sur votre téléphone

### Étapes d'installation

1. **Installer les dépendances**

   ```bash
   npm install
   ```

2. **Lancer l'application**

   ```bash
   npx expo start
   ```

3. **Scanner le QR code**
   - Sur Android : utilisez l'app Expo Go
   - Sur iOS : utilisez la caméra native
   - Ou appuyez sur 'a' pour Android emulator ou 'i' pour iOS simulator

## 👥 Comptes de test

### Patient

- **Email**: patient@test.com
- **Mot de passe**: patient123

### Pharmacien

- **Email**: pharmacien@test.com
- **Mot de passe**: pharma123

## 🗂️ Structure du projet

```
src/
├── api/                      # Services AsyncStorage
│   ├── asyncStorage.js       # Generic storage functions
│   ├── userService.js        # User authentication
│   ├── patientService.js     # Patient CRUD
│   ├── medicamentService.js  # Medicine CRUD
│   ├── ordonnanceService.js  # Prescription management
│   └── commandeService.js    # Order management
├── components/
│   ├── common/               # Reusable components
│   │   ├── Button.js
│   │   ├── Input.js
│   │   ├── Card.js
│   │   └── LoadingSpinner.js
│   ├── patient/              # Patient-specific components
│   │   ├── OrdonnanceItem.js
│   │   └── CommandeItem.js
│   └── pharmacien/           # Pharmacist-specific components
│       ├── CommandeStatusBadge.js
│       └── MedicamentItem.js
├── screens/
│   ├── auth/
│   │   └── LoginScreen.js
│   ├── patient/
│   │   ├── OrdonnanceListScreen.js
│   │   ├── OrdonnanceDetailScreen.js
│   │   ├── CommandeCreateScreen.js
│   │   ├── CommandeListScreen.js
│   │   └── CommandeDetailScreen.js
│   └── pharmacien/
│       ├── CommandeListScreen.js
│       ├── CommandeDetailScreen.js
│       ├── MedicamentListScreen.js
│       └── MedicamentFormScreen.js
├── store/                    # Zustand state management
│   ├── authStore.js
│   ├── patientStore.js
│   ├── medicamentStore.js
│   ├── ordonnanceStore.js
│   └── commandeStore.js
├── navigation/
│   ├── AppNavigator.js       # Main navigator
│   ├── AuthNavigator.js
│   ├── PatientNavigator.js
│   └── PharmacienNavigator.js
└── data/
    └── seedData.js          # Initial sample data
```

## 💾 Stockage des données

L'application utilise **AsyncStorage** pour le stockage local des données :

- `users` : Comptes utilisateurs
- `patients` : Informations patients
- `medicaments` : Catalogue des médicaments
- `ordonnances` : Prescriptions médicales
- `commandes` : Commandes de médicaments

Les données sont automatiquement initialisées au premier lancement avec des exemples.

## 🔄 Flux de fonctionnement

1. **Le patient** se connecte et consulte ses ordonnances
2. Il sélectionne une ordonnance et la transforme en commande
3. Il choisit une pharmacie et indique le lieu de livraison
4. **Le pharmacien** reçoit la commande avec le statut "En attente"
5. Il met à jour le statut : En attente → En préparation → Prête
6. **Le patient** peut suivre l'évolution du statut de sa commande

## 📚 Technologies utilisées

- **React Native** avec Expo
- **Zustand** pour la gestion d'état
- **React Navigation** (Native Stack + Bottom Tabs)
- **AsyncStorage** pour la persistance locale
- **Ionicons** pour les icônes

## 🔧 Fonctionnalités techniques

- ✅ Authentification par rôle
- ✅ Navigation conditionnelle basée sur le rôle
- ✅ Gestion d'état global avec Zustand
- ✅ Persistance des données avec AsyncStorage
- ✅ Composants réutilisables
- ✅ Validation des formulaires
- ✅ Gestion des erreurs
- ✅ Loading states

## 📝 Notes importantes

- **Pas de base de données externe** : Toutes les données sont stockées localement
- **Pas de XAMPP nécessaire** : Application mobile autonome
- Le rôle **Médecin** n'est pas implémenté dans le code (uniquement dans le contexte)
- Les données sont réinitialisées si AsyncStorage est vidé

## 🎨 Personnalisation

Pour modifier les couleurs, consultez les fichiers de styles dans chaque composant.
Les couleurs principales :

- Primary: `#007AFF` (bleu iOS)
- Success: `#34C759` (vert)
- Warning: `#FF9500` (orange)
- Danger: `#FF3B30` (rouge)

## 🐛 Dépannage

Si l'application ne démarre pas :

```bash
# Nettoyer le cache
npx expo start -c

# Réinstaller les dépendances
rm -rf node_modules
npm install
```

---

**Développé pour le projet de Gestion d'Ordonnances Médicales - React Native**
