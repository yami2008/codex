# Schéma physique — Contrat

> **Service :** `operation-service`  
> **SGBD :** SQL Server  
> **Base :** `egsa_operation`

## TABLE — contrats

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | annee | `char(4)` | Non | Non | Non | — |
| 3 | numero_brouillon | `int` | Non | Non | Non | — |
| 4 | numero_officiel | `nvarchar(100)` | Oui | Non | Non | — |
| 5 | type_contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 7 | client_id | `uniqueidentifier` | Non | Non | Non | — |
| 8 | objet | `nvarchar(500)` | Non | Non | Non | — |
| 9 | client_signataire_nom | `nvarchar(150)` | Oui | Non | Non | — |
| 10 | client_signataire_fonction | `nvarchar(150)` | Oui | Non | Non | — |
| 11 | client_raison_sociale_snapshot | `nvarchar(200)` | Oui | Non | Non | — |
| 12 | client_nif_snapshot | `nvarchar(50)` | Oui | Non | Non | — |
| 13 | client_rc_snapshot | `nvarchar(50)` | Oui | Non | Non | — |
| 14 | client_adresse_snapshot | `nvarchar(300)` | Oui | Non | Non | — |
| 15 | represente_par | `nvarchar(200)` | Oui | Non | Non | — |
| 17 | date_creation | `date` | Non | Non | Non | (CONVERT([date],sysutcdatetime())) |
| 18 | date_effet | `date` | Oui | Non | Non | — |
| 19 | periodicite_facturation | `nvarchar(20)` | Non | Non | Non | — |
| 20 | is_paiement_avance | `bit` | Non | Non | Non | ((0)) |
| 21 | compte_bancaire_id | `uniqueidentifier` | Oui | Non | Non | — |
| 22 | taux_revision_annuel | `decimal(5,2)` | Non | Non | Non | ((0)) |
| 23 | devise | `nvarchar(10)` | Non | Non | Non | ('DZD') |
| 24 | taux_conversion | `decimal(15,6)` | Non | Non | Non | ((1)) |
| 25 | is_facturation_bloquee | `bit` | Non | Non | Non | ((0)) |
| 26 | statut | `nvarchar(25)` | Non | Non | Non | ('BROUILLON') |
| 27 | alerte_expiration_traitee_at | `datetime2(7)` | Oui | Non | Non | — |
| 28 | alerte_expiration_traitee_par | `nvarchar(100)` | Oui | Non | Non | — |
| 29 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 30 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 31 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 32 | duree_mois | `int` | Non | Non | Non | — |
| 33 | date_expiration | `date` | Oui | Non | Oui — (dateadd(day,(-1),dateadd(month,[duree_mois],[date_effet]))) | — |
| 33 | contrat_racine_id | `uniqueidentifier` | Non | Non | Non | — |
| 34 | contrat_precedent_id | `uniqueidentifier` | Oui | Non | Non | — |
| 35 | numero_avenant | `int` | Non | Non | Non | ((0)) |
| 36 | objet_avenant | `nvarchar(500)` | Oui | Non | Non | — |
| 37 | is_current_used | `bit` | Non | Non | Non | ((1)) |
| 38 | is_regularisation | `bit` | Non | Non | Non | ((0)) |
| 39 | service_gestionnaire | `nvarchar(30)` | Non | Non | Non | — |
| 40 | mode_passation | `nvarchar(20)` | Non | Non | Non | — |
| 41 | numero_ao | `nvarchar(50)` | Oui | Non | Non | — |
| 42 | date_lancement_ao | `date` | Oui | Non | Non | — |
| 43 | date_transmission_visa | `date` | Oui | Non | Non | — |
| 44 | numero_visa | `nvarchar(50)` | Oui | Non | Non | — |
| 45 | date_visa | `date` | Oui | Non | Non | — |
| 46 | observations_visa | `nvarchar(1000)` | Oui | Non | Non | — |
| 47 | date_signature_dg | `date` | Oui | Non | Non | — |
| 48 | signataire_egsa_nom | `nvarchar(150)` | Oui | Non | Non | — |
| 49 | signataire_egsa_fonction | `nvarchar(150)` | Oui | Non | Non | — |
| 50 | annee_enregistrement | `char(4)` | Oui | Non | Non | — |
| 51 | notification_client_effectuee | `bit` | Non | Non | Non | ((0)) |
| 52 | notification_client_date | `date` | Oui | Non | Non | — |
| 53 | titre_convention | `nvarchar(50)` | Non | Non | Non | ('Occupation temporaire') |
| 54 | date_signature_client | `date` | Oui | Non | Non | — |

### Clé primaire et index

- **PK PK_contrats :** `id`
- **UQ_contrats_brouillon** [UNIQUE, CONSTRAINT] — NONCLUSTERED : `annee`, `numero_brouillon`
- **IX_contrats_client** — NONCLUSTERED : `client_id`
- **IX_contrats_compte_bancaire** — NONCLUSTERED : `compte_bancaire_id`
- **IX_contrats_expiration** — NONCLUSTERED : `date_expiration`; INCLUDE : `alerte_expiration_traitee_at`, `statut`
- **IX_contrats_racine** — NONCLUSTERED : `contrat_racine_id`, `numero_avenant`
- **UX_contrats_officiel** [UNIQUE, filtré] — NONCLUSTERED : `annee`, `numero_officiel`, `numero_avenant` ; filtre : `numero_officiel IS NOT NULL` (seuls les contrats avec un numéro officiel renseigné sont concernés)
- **UX_contrats_racine_en_cours** [UNIQUE, filtré] — NONCLUSTERED : `contrat_racine_id` ; filtre serveur : `statut <> 'OFFICIEL' AND statut <> 'RESILIE' AND statut <> 'ABANDONNE' AND statut <> 'REFUSE_PAR_CLIENT'`.

### Clés étrangères

- **FK_contrats_precedent :** (contrat_precedent_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION
- **FK_contrats_racine :** (contrat_racine_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION
- **FK_contrats_type :** (type_contrat_id → id) → contrats_types ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — contrats_aeroports

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | — |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | aeroport_id | `uniqueidentifier` | Non | Non | Non | — |
| 4 | aeroport_nom_snapshot | `varchar(150)` | Oui | Non | Non | — |
| 5 | created_at | `datetime2(7)` | Non | Non | Non | — |
| 6 | updated_at | `datetime2(7)` | Non | Non | Non | — |

### Clé primaire et index

- **PK PK__contrats__3213E83FDAE6BBD2 :** `id`

### Clés étrangères

- **FK_contrats_aeroports_contrats :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE CASCADE

## TABLE — contrats_biens

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | bien_id | `uniqueidentifier` | Non | Non | Non | — |
| 4 | mode_tarification | `nvarchar(10)` | Non | Non | Non | — |
| 5 | surface_louee_m2 | `decimal(10,2)` | Oui | Non | Non | — |
| 6 | tarif_reference_lf | `decimal(15,2)` | Oui | Non | Non | — |
| 7 | tarif_commercial | `decimal(15,2)` | Oui | Non | Non | — |
| 8 | montant_forfaitaire | `decimal(15,2)` | Oui | Non | Non | — |
| 9 | taux_tva | `decimal(5,2)` | Non | Non | Non | ((19)) |
| 10 | zone | `nvarchar(100)` | Oui | Non | Non | — |
| 11 | nature_occupation | `nvarchar(150)` | Oui | Non | Non | — |
| 12 | objet_attribution | `nvarchar(200)` | Oui | Non | Non | — |
| 13 | commentaire | `nvarchar(500)` | Oui | Non | Non | — |
| 14 | numero_pv_attribution | `nvarchar(50)` | Oui | Non | Non | — |
| 15 | date_pv_attribution | `date` | Oui | Non | Non | — |
| 16 | bien_code_snapshot | `nvarchar(50)` | Oui | Non | Non | — |
| 17 | bien_designation_snapshot | `nvarchar(200)` | Oui | Non | Non | — |
| 18 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 19 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 20 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 21 | grille_tarif_id | `uniqueidentifier` | Oui | Non | Non | — |

### Clé primaire et index

- **PK PK_contrats_biens :** `id`
- **IX_contrats_biens_bien** — NONCLUSTERED : `bien_id`
- **IX_contrats_biens_contrat** — NONCLUSTERED : `contrat_id`

### Clés étrangères

- **FK_contrats_biens_contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — contrats_services

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 4 | mode_tarification | `nvarchar(15)` | Non | Non | Non | — |
| 5 | prix_unitaire | `decimal(15,2)` | Oui | Non | Non | — |
| 6 | unite_facturation | `nvarchar(30)` | Oui | Non | Non | — |
| 7 | montant_forfaitaire | `decimal(15,2)` | Oui | Non | Non | — |
| 8 | commentaire | `nvarchar(500)` | Oui | Non | Non | — |
| 9 | service_code_snapshot | `nvarchar(20)` | Oui | Non | Non | — |
| 10 | service_libelle_snapshot | `nvarchar(200)` | Oui | Non | Non | — |
| 11 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 12 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 13 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 14 | catalogue_service_id | `int` | Oui | Non | Non | — |

### Clé primaire et index

- **PK PK_contrats_services :** `id`
- **IX_contrats_serv_contrat** — NONCLUSTERED : `contrat_id`

### Clés étrangères

- **FK_contrats_serv_contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — contrats_echeances

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | contrats_bien_id | `uniqueidentifier` | Oui | Non | Non | — |
| 4 | numero_echeance | `int` | Non | Non | Non | — |
| 5 | periode_debut | `date` | Non | Non | Non | — |
| 6 | periode_fin | `date` | Non | Non | Non | — |
| 7 | date_echeance | `date` | Non | Non | Non | — |
| 8 | is_active | `bit` | Non | Non | Non | ((1)) |
| 9 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 10 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 11 | contrats_service_id | `uniqueidentifier` | Oui | Non | Non | — |
| 12 | annee_contrat | `tinyint` | Non | Non | Non | — |

### Clé primaire et index

- **PK PK_contrats_echeances :** `id`
- **IX_contrats_ech_contrat_date** — NONCLUSTERED : `contrat_id`, `date_echeance`; INCLUDE : `contrats_bien_id`, `contrats_service_id`, `is_active`, `numero_echeance`
- **IX_contrats_ech_service** — NONCLUSTERED : `contrats_service_id`
- **UX_contrats_ech_bien_numero** [UNIQUE, filtré] — NONCLUSTERED : `contrats_bien_id`, `numero_echeance` ; filtre serveur : `contrats_bien_id IS NOT NULL`.
- **UX_contrats_ech_service_numero** [UNIQUE, filtré] — NONCLUSTERED : `contrats_service_id`, `numero_echeance` ; filtre serveur : `contrats_service_id IS NOT NULL`.

### Clés étrangères

- **FK_contrats_ech_bien :** (contrats_bien_id → id) → contrats_biens ; UPDATE NO_ACTION ; DELETE NO_ACTION
- **FK_contrats_ech_contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION
- **FK_contrats_ech_service :** (contrats_service_id → id) → contrats_services ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — contrats_cautions

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | type_caution | `nvarchar(30)` | Non | Non | Non | — |
| 4 | is_complement | `bit` | Non | Non | Non | ((0)) |
| 5 | montant | `decimal(15,2)` | Non | Non | Non | — |
| 6 | reference | `nvarchar(100)` | Oui | Non | Non | — |
| 7 | date_caution | `date` | Non | Non | Non | — |
| 8 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 9 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |

### Clé primaire et index

- **PK PK_contrats_cautions :** `id`
- **IX_contrats_cautions_contrat** — NONCLUSTERED : `contrat_id`

### Clés étrangères

- **FK_contrats_cautions_contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — contrats_envois

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | numero_envoi | `int` | Non | Non | Non | — |
| 4 | date_envoi | `date` | Non | Non | Non | — |
| 5 | objet | `nvarchar(300)` | Non | Non | Non | — |
| 6 | date_rappel | `date` | Oui | Non | Non | — |
| 7 | date_retour_client | `date` | Oui | Non | Non | — |
| 8 | reponse_client | `nvarchar(20)` | Oui | Non | Non | — |
| 9 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 10 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |

### Clé primaire et index

- **PK PK_contrats_envois :** `id`
- **UQ_contrats_envois** [UNIQUE, CONSTRAINT] — NONCLUSTERED : `contrat_id`, `numero_envoi`

### Clés étrangères

- **FK_contrats_envois_contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — contrats_pieces_jointes

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | contrats_historique_statut_id | `uniqueidentifier` | Oui | Non | Non | — |
| 4 | type_document | `nvarchar(30)` | Non | Non | Non | — |
| 5 | nom_fichier | `nvarchar(255)` | Non | Non | Non | — |
| 6 | chemin_fichier | `nvarchar(500)` | Non | Non | Non | — |
| 7 | hash_fichier | `char(64)` | Non | Non | Non | — |
| 8 | type_mime | `nvarchar(100)` | Non | Non | Non | — |
| 9 | taille_octets | `bigint` | Non | Non | Non | — |
| 10 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 11 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 12 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |

### Clé primaire et index

- **PK PK_contrats_pieces_jointes :** `id`
- **UQ_contrats_pj_hash** [UNIQUE, CONSTRAINT] — NONCLUSTERED : `contrat_id`, `hash_fichier`
- **IX_contrats_pj_evenement** — NONCLUSTERED : `contrats_historique_statut_id`

### Clés étrangères

- **FK_contrats_pj_contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION
- **FK_contrats_pj_historique :** (contrats_historique_statut_id → id) → contrats_historique_statuts ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — contrats_historique_statuts

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | statut | `nvarchar(25)` | Non | Non | Non | — |
| 4 | commentaire | `nvarchar(1000)` | Oui | Non | Non | — |
| 5 | date_effet | `date` | Oui | Non | Non | — |
| 6 | numero_decision | `nvarchar(50)` | Oui | Non | Non | — |
| 7 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 8 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |

### Clé primaire et index

- **PK PK_contrats_historique_statuts :** `id`
- **IX_contrats_hist_contrat** — NONCLUSTERED : `contrat_id`, `created_at`

### Clés étrangères

- **FK_contrats_hist_contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE NO_ACTION
- **FK_contrats_compte_bancaire :** (compte_bancaire_id → id) → comptes_bancaires ; UPDATE NO_ACTION ; DELETE NO_ACTION

## TABLE — comptes_bancaires

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | libelle | `nvarchar(100)` | Non | Non | Non | — |
| 3 | banque | `nvarchar(150)` | Non | Non | Non | — |
| 4 | agence | `nvarchar(150)` | Non | Non | Non | — |
| 5 | rib | `nvarchar(255)` | Non | Non | Non | — |
| 6 | is_active | `bit` | Non | Non | Non | ((1)) |
| 7 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 8 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 9 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |

### Clé primaire et index

- **PK PK_comptes_bancaires :** `id`

### Clés étrangères

- Aucune.

## TABLE — contrats_rips

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | rip | `nvarchar(255)` | Non | Non | Non | — |
| 4 | created_at | `datetime` | Non | Non | Non | (getdate()) |
| 5 | updated_at | `datetime` | Non | Non | Non | (getdate()) |

### Clé primaire et index

- **PK PK__contrats__3213E83FA796EB79 :** `id`

### Clés étrangères

- **FK_ContratsRips_Contrat :** (contrat_id → id) → contrats ; UPDATE NO_ACTION ; DELETE CASCADE

## TABLE — contrats_grille_tarifs

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | type_contrat_id | `uniqueidentifier` | Non | Non | Non | — |
| 3 | libelle | `nvarchar(200)` | Non | Non | Non | — |
| 4 | is_national | `bit` | Non | Non | Non | ((0)) |
| 5 | prix_unitaire_m2 | `decimal(15,2)` | Non | Non | Non | — |
| 6 | is_active | `bit` | Non | Non | Non | ((1)) |
| 7 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 8 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 9 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |

### Clé primaire et index

- **PK PK_contrats_grille_tarifs :** `id`
- **UQ_contrats_grille** [UNIQUE, CONSTRAINT] — NONCLUSTERED : `type_contrat_id`, `libelle`, `is_national`
- **IX_contrats_grille_type_national** — NONCLUSTERED : `type_contrat_id`, `is_national`, `is_active`; INCLUDE : `libelle`, `prix_unitaire_m2`

### Clés étrangères

- Aucune clé étrangère observée

## TABLE — contrats_types

### Colonnes

| Ordre | Colonne | Type SQL | NULL | Identité | Calculée | Défaut |
|---:|---|---|:---:|:---:|:---:|---|
| 1 | id | `uniqueidentifier` | Non | Non | Non | (newid()) |
| 2 | code | `nvarchar(20)` | Non | Non | Non | — |
| 3 | libelle | `nvarchar(100)` | Non | Non | Non | — |
| 4 | is_active | `bit` | Non | Non | Non | ((1)) |
| 5 | created_by | `nvarchar(100)` | Non | Non | Non | — |
| 6 | created_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 7 | updated_at | `datetime2(7)` | Non | Non | Non | (sysutcdatetime()) |
| 8 | is_tarif_verrouille | `bit` | Non | Non | Non | ((0)) |

### Clé primaire et index

- **PK PK_contrats_types :** `id`
- **UQ_contrats_types_code** [UNIQUE, CONSTRAINT] — NONCLUSTERED : `code`
- **IX_contrats_types_actif** — NONCLUSTERED : `is_active`; INCLUDE : `code`, `is_tarif_verrouille`, `libelle`

### Clés étrangères

- Aucune clé étrangère observée
