# Structure de référence du prd.md

Adapter les sections au projet : en retirer ou en ajouter si l'interview le justifie.
Remplacer tout le contenu d'exemple par les réponses actées.

```markdown
# PRD — <Nom du projet>

> **Document :** Vision produit & référence équipe
> **Version :** 1.0 | **Date :** <Mois Année> | **Statut :** Validé

---

## 1. Contexte & Problème

<Situation actuelle, en 2-3 phrases courtes.>

**Le problème :** <données dispersées, erreurs manuelles, etc.>

**La solution :** <une phrase : ce que le produit apporte.>

---

## 2. Objectifs & Critères de succès

| Objectif   | Critère de succès mesurable |
| :--------- | :-------------------------- |
| <objectif> | <critère vérifiable>        |

---

## 3. Utilisateurs cibles

| Profil    | Rôle dans le produit |
| :-------- | :------------------- |
| <profil>  | <ce qu'il y fait>    |

---

## 4. Stack technique

| Couche               | Technologie |
| :------------------- | :---------- |
| **Frontend**         |             |
| **UI**               |             |
| **Backend**          |             |
| **Base de données**  |             |
| **Authentification** |             |
| **Gestion du code**  |             |
| **Hébergement**      |             |

---

## 5. Architecture — Principes non négociables

- <principe 1 : monolithe/microservices + règle associée.>
- <principe 2 : sécurité/auth.>
- <principe 3 : hébergement/déploiement.>

---

## 6. Modules — Périmètre & Priorités

### 🔴 MODULE 1 — <Nom> (Priorité 1 — développement actif)

**Objectif :** <une phrase.>

---

### MODULE 2 — <Nom>

- Plus de détails plus tard.

---

<Répéter par module. Une ligne finale si d'autres modules sont envisagés plus tard.>

---

## 7. Contraintes majeures

- **<Contrainte> :** <impact concret, phrases courtes.>
```

## Rappels de style

- Une idée par ligne. Utiliser `\` en fin de ligne pour couper les phrases longues.
- Les tableaux restent compacts : pas de paragraphes dans les cellules.
- Pas de section vide : supprimer plutôt que laisser un placeholder.
