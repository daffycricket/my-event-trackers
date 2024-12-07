P1 fonctionnel
| Tâche | Statut |
|-------|--------|
| Paramétrer le référentiel de foods pour qu'une unité soit définie par food : nombre d'unité, poids, volume, etc. | todo ||
| Bug : à la création d'un repas, si j'ajoute plusieurs fois le même aliment, il n'est pas marqué comme sélectionné | done | c1c1d1e |
| Implémenter l'authentification utilisateur (email/mot de passe) | todo ||
| Implémenter l'authentification utilisateur (email/mot de passe) | todo ||
| Implémenter la synchronisation des données hors-ligne | todo ||
| Implémenter la gestion des erreurs et les messages utilisateur | todo ||
| Implémenter in app purchase pour abonnement premium | todo ||
| Restreindre l'accès à certaines fonctionnalités : suivi des events sur plus de 1 mois + certains graphiques | todo ||
| Permettre l'ajout d'une photo à un événement | todo ||
| Implémenter la recherche et le filtrage des événements | todo ||
| Ajouter des graphiques statistiques interactifs | done |17372a6|
| Mettre en place un système de notifications | todo ||
| Implémenter l'export des données au format CSV/PDF | todo ||
| Implémenter la gestion des fuseaux horaires | todo ||
| Ajouter la pagination des listes d'événements | todo ||

P1 technique
| Tâche | Statut |
|-------|--------|
| Installer Elasticsearch pour le monitoring | todo ||
| Dockeriser l'api pour déployer sur cloud run | todo ||
| Ajouter les tests d'intégration de l'API | todo ||
| Implémenter les endpoints manquants de l'API | todo ||
| Configurer le monitoring et les analytics | todo ||
| Mettre en place la validation des données avec Pydantic | todo ||
| Ajouter la validation des données côté client | todo ||
| Mettre en place des tests unitaires Flutter | todo ||
| Optimiser les performances de l'application | todo ||



P1 : obligatoire pour le déploiement sur les les stores
| Tâche | Statut |
|-------|--------|
| Créer une politique de confidentialité | todo |
| Créer des conditions d'utilisation | todo |
| Créer des captures d'écran pour les stores (différentes tailles) | todo |
| Créer une icône de l'application aux formats requis | todo |
| Force update de l'app | todo |
| Popup d'affichage d'acceptation des analytics | todo |
| Rédiger une description détaillée de l'application | todo |
| Définir les mots-clés pertinents | todo |
| Obtenir un compte développeur Apple ($99/an) | todo |
| Configurer le versioning (numéro de version et build) | todo |
| Préparer les fichiers binaires signés (APK/Bundle pour Android, IPA pour iOS) | todo |
| Remplir tous les formulaires de classification d'âge | todo |
| Vérifier la conformité RGPD/GDPR | todo |
| Préparer les réponses aux questions de review | todo |
| Configurer les in-app purchases si nécessaire | todo |
| Tester l'application sur différents appareils | todo |
| Optimiser la taille de l'application | todo |
| Préparer un site web de support/landing page | todo |


P2
| Documenter l'API avec FastAPI/Swagger | todo |
| Mettre en place le CI/CD pour l'app et l'API | todo |


## Documentation API

### Endpoints

| Endpoint | Description | Payload & Réponse |
|----------|-------------|-------------------|
| **Authentification** |
| POST /api/auth/register | Inscription d'un nouvel utilisateur | Request: ```json { "email": "user@example.com", "password": "secret", "name": "John Doe" }``` <br>Response: ```json { "token": "jwt_token", "user": { "id": 1, "email": "user@example.com", "name": "John Doe" } }``` |
| POST /api/auth/login | Connexion utilisateur | Request: ```json { "email": "user@example.com", "password": "secret" }``` <br>Response: ```json { "token": "jwt_token" }``` |
| POST /api/auth/logout | Déconnexion | Request: ∅ <br>Response: ```json { "message": "Déconnecté avec succès" }``` |
| **Événements** |
| GET /api/events | Liste des événements (paginée) | Response: ```json { "items": [...], "total": 100, "page": 1, "per_page": 20 }``` |
| POST /api/events | Création d'un événement | Request: ```json { "title": "Meeting", "start_time": "2024-03-21T14:00:00+01:00", "end_time": "2024-03-21T15:00:00+01:00", "timezone": "Europe/Paris" }``` <br>Response: ```json { "id": 1, "title": "Meeting", ... }``` |
| PUT /api/events/{id} | Modification d'un événement | Request: ```json { "title": "Updated Meeting" }``` <br>Response: ```json { "id": 1, "title": "Updated Meeting", ... }``` |
| DELETE /api/events/{id} | Suppression d'un événement | Response: ```json { "message": "Événement supprimé" }``` |
| POST /api/events/{id}/photos | Ajout d'une photo | Request: `multipart/form-data` avec fichier image <br>Response: ```json { "photo_url": "https://..." }``` |
| GET /api/events/search | Recherche d'événements | Query: `?q=meeting&start_date=2024-03-21` <br>Response: ```json { "items": [...], "total": 5 }``` |
| **Synchronisation** |
| GET /api/events/sync | Récupère les modifications depuis last_sync | Query: `?last_sync=2024-03-21T14:00:00Z` <br>Response: ```json { "created": [...], "updated": [...], "deleted": [...] }``` |
| POST /api/events/sync | Envoie les modifications locales | Request: ```json { "created": [...], "updated": [...], "deleted": [...] }``` |
| **Export** |
| GET /api/export/events/csv | Export CSV des événements | Response: `text/csv` fichier |
| GET /api/export/events/pdf | Export PDF des événements | Response: `application/pdf` fichier |
| **Configuration** |
| GET /api/config/timezones | Liste des fuseaux horaires | Response: ```json { "timezones": ["Europe/Paris", "America/New_York", ...] }``` |
| GET /api/config/app-version | Version minimale requise | Response: ```json { "min_version": "1.0.0", "latest_version": "1.2.0" }``` |
| **Notifications** |
| GET /api/notifications | Liste des notifications | Response: ```json { "items": [{ "id": 1, "message": "Nouveau commentaire", "read": false }] }``` |
| PUT /api/notifications/{id}/read | Marquer comme lu | Response: ```json { "id": 1, "read": true }``` |
| **Utilisateur** |
| GET /api/users/me | Profil utilisateur | Response: ```json { "id": 1, "email": "user@example.com", "preferences": {...} }``` |
| PUT /api/users/preferences | Mise à jour préférences | Request: ```json { "timezone": "Europe/Paris", "notification_enabled": true }``` |

### Notes sur l'API

- Tous les endpoints (sauf auth) nécessitent un header `Authorization: Bearer <token>`
- Les dates sont en ISO 8601 avec timezone
- La pagination utilise les paramètres `page` et `per_page`
- Les réponses d'erreur suivent le format : ```json { "error": "message", "code": "ERROR_CODE" }```
- Les listes paginées retournent toujours : ```json { "items": [...], "total": n, "page": x, "per_page": y }```
