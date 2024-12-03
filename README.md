# My Event Tracker

Une application mobile Flutter pour suivre et gérer vos événements.

## Description

My Event Tracker est une application mobile qui permet aux utilisateurs de :
- Créer et gérer des événements personnels
- Suivre les dates importantes
- Recevoir des notifications pour les événements à venir
- Organiser les événements par catégories

## Installation

1. Assurez-vous d'avoir Flutter installé sur votre machine

```bash
flutter --version
```

2. Installez watchexec 

```bash
brew install watchexec` sur macOS
```

3. Clonez le repository

```bash
git clone https://github.com/votre-username/my-event-trackers.git
```

4. Installez les dépendances

```bash
cd my-event-trackers
flutter pub get
```

5. Lancez l'application

```bash
flutter run
```

## Fonctionnalités

- 📅 Création d'événements avec date et heure
- 📱 Interface utilisateur intuitive
- 🎨 Design moderne et responsive
- 📁 Organisation par catégories

## Technologies utilisées

- Flutter
- Dart
- Riverpod (gestion d'état)

## Structure du projet

```
lib/
  ├── models/        # Modèles de données
  ├── screens/       # Écrans de l'application
  ├── widgets/       # Widgets réutilisables
  ├── services/      # Services (BDD, API, etc.)
  ├── utils/         # Utilitaires
  └── main.dart      # Point d'entrée de l'application
```

## Génération automatique des traductions
La génération automatique des traductions se lance automatiquement à l'ouverture du projet dans VS Code. Les fichiers de traduction (`.arb`) dans `lib/l10n` seront surveillés et les fichiers de localisation seront régénérés à chaque modification.

Si la tâche ne se lance pas automatiquement :
1. Cmd/Ctrl + Shift + P
2. Taper "Tasks: Run Task"
3. Sélectionner "Watch L10n"

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE.md](LICENSE.md) pour plus de détails.

## Contact

Votre Nom - [@votre_twitter](https://twitter.com/votre_twitter)

Lien du projet: [https://github.com/votre-username/my-event-trackers](https://github.com/votre-username/my-event-trackers)