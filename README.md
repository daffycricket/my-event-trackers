# My Event Tracker

## Configuration du projet

### Prérequis
- Flutter SDK
- watchexec (`brew install watchexec` sur macOS)
- VS Code avec l'extension Flutter

### Installation
1. Cloner le projet
2. Installer les dépendances : `flutter pub get`
3. Ouvrir le projet dans VS Code

La génération automatique des traductions se lance automatiquement à l'ouverture du projet dans VS Code. Les fichiers de traduction (`.arb`) dans `lib/l10n` seront surveillés et les fichiers de localisation seront régénérés à chaque modification.

Si la tâche ne se lance pas automatiquement :
1. Cmd/Ctrl + Shift + P
2. Taper "Tasks: Run Task"
3. Sélectionner "Watch L10n"
