# PRD — ERP EGSA (Établissement de Gestion et Service Aéroportuaire)

> **Document :** Vision produit & référence équipe
> **Version :** 2.0 | **Date :** Mai 2026 | **Statut :** Validé

---

## 1. Contexte & Problème

L'EGSA gère 17 aéroports.\
Aujourd'hui, la majorité des processus métier (facturation, paie, stocks, RH) repose sur Excel et du papier.\
Il n'existe aucune visibilité centralisée pour la Direction Générale (DG).

**Le problème :** Des données dispersées, des calculs manuels sources d'erreurs,\
des encaissements non sécurisés, et une impossibilité de piloter l'activité en temps réel depuis la DG.

**La solution :** Un ERP web interne, multi-sites, couvrant l'ensemble des directions métier de l'EGSA.

---

## 2. Objectifs & Critères de succès

| Objectif | Critère de succès mesurable |
| :--- | :--- |
| Centralisation des données | 100% des 17 sites connectés, données visibles en temps réel depuis la DG |
| Fiabilité financière | Zéro calcul manuel de redevances — 100% automatisé via le moteur de calcul |
| Sécurisation des encaissements | Toute transaction de caisse tracée et non modifiable après validation |
| Continuité opérationnelle | Mode offline Caisse/Perception fonctionnel ≥ 24h sans VPN *(version ultérieure)* |
| Adoption terrain | Les agents opérationnels n'utilisent plus Excel pour les processus couverts par l'ERP |

---

## 3. Utilisateurs cibles

| Profil | Rôle dans l'ERP |
| :--- | :--- |
| **Agents opérationnels** | Saisie, émission de factures, encaissements au guichet (17 aéroports) |
| **Responsables & Direction** | Validation des opérations, supervision, reporting, contrôle de gestion |
| **Administrateurs système** | Gestion des accès et rôles (Keycloak), paramétrage des tarifs nationaux |

---

## 4. Stack technique

| Couche | Technologie |
| :--- | :--- |
| **Frontend** | Angular 21 — Standalone Components + Signals + NgRx (State Management) |
| **UI** | Tailwind CSS 4 + PrimeNG 21 |
| **Backend** | Spring Boot 4.1.0 — architecture microservices (Java 17 pour `auth-service`, Java 21 pour les autres services) |
| **Base de données** | SQL Server — une base dédiée par microservice |
| **Authentification** | Keycloak (SSO) via Spring Security OAuth2 |
| **Gestion du code** | GitLab — hébergement interne EGSA |
| **Hébergement** | Infrastructure interne EGSA — accès inter-sites via VPN |

---

## 5. Architecture — Principes non négociables

- **Microservices :** Chaque service métier est indépendant et possède sa propre base de données.\
  Aucun service n'accède directement à la base de données d'un autre.
- **Sécurité :** Keycloak est le point unique d'authentification et de gestion des rôles.\
  Les rôles par endpoint sont documentés dès le développement, même avant l'intégration Keycloak finale.
- **Hébergement interne :** L'ERP est déployé sur l'infrastructure réseau de l'EGSA.\
  Pas de cloud public.

---

## 6. Modules — Périmètre & Priorités

### 🔴 MODULE 1 — Commercial (Priorité 1 — développement actif)
**Objectif :** Gérer l'intégralité du cycle de revenus de l'EGSA.

---

### MODULE 2 — Ressources Humaines
- Plus de détails plus tard.

---

### MODULE 3 — Finance & Comptabilité
- Plus de détails plus tard.

---

### MODULE 4 — Achats & Stock
- Plus de détails plus tard.

---

- D'autres modules pourraient venir, mais c'est dans le futur loin, pour le moment, la priorité est dans ces modules.

---

## 7. Contraintes majeures

- **Réseau VPN :** La connectivité entre les 17 sites et la DG est variable.\
  L'application doit fonctionner en mode dégradé en cas de latence élevée, hors fonctionnement hors ligne prévu ultérieurement.
- **Équipe :** 5 développeurs — développement séquentiel, un module à la fois, en partant du Commercial.
- **Keycloak :** L'intégration SSO complète est faite après validation fonctionnelle du module Commercial.\
  Les endpoints documentent leurs rôles requis dès le développement.
- **Données sensibles :** Données de paie, RH et financières soumises à confidentialité — accès strictement contrôlé par rôle Keycloak.
