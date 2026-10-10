-- =============================================================================
-- MODULE : CONTRAT
-- Date   : 2026-08-19
-- Moteur : SQL Server (T-SQL)
-- =============================================================================
-- Correspondance : ERP_Docs/Modules/Contrat/schema.contrat.md.
-- Le script contient uniquement la structure physique : tables, colonnes,
-- valeurs par défaut, clés, index et clés étrangères.
-- Script idempotent : les tables existantes ne sont pas recréées.
--
-- Ordre des tables :
--   1. contrats_grille_tarifs
--   2. contrats_types
--   3. contrats
--   4. comptes_bancaires
--   5. contrats_aeroports
--   6. contrats_biens
--   7. contrats_cautions
--   8. contrats_envois
--   9. contrats_historique_statuts
--   10. contrats_rips
--   11. contrats_services
--   12. contrats_echeances
--   13. contrats_pieces_jointes
-- =============================================================================

USE [egsa_operation];
GO
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

-- =============================================================================
-- TABLE 1 : contrats_grille_tarifs
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_grille_tarifs', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_grille_tarifs] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_grille_tarifs_id] DEFAULT (newid()),
        [type_contrat_id] uniqueidentifier NOT NULL,
        [libelle] nvarchar(200) NOT NULL,
        [is_national] bit NOT NULL CONSTRAINT [DF_contrats_grille_tarifs_is_national] DEFAULT ((0)),
        [prix_unitaire_m2] decimal(15,2) NOT NULL,
        [is_active] bit NOT NULL CONSTRAINT [DF_contrats_grille_tarifs_is_active] DEFAULT ((1)),
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_grille_tarifs_created_at] DEFAULT (sysutcdatetime()),
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_grille_tarifs_updated_at] DEFAULT (sysutcdatetime()),
        CONSTRAINT [PK_contrats_grille_tarifs] PRIMARY KEY ([id]),
        CONSTRAINT [UQ_contrats_grille] UNIQUE ([type_contrat_id], [libelle], [is_national])
    );
END
GO

-- =============================================================================
-- TABLE 2 : contrats_types
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_types', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_types] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_types_id] DEFAULT (newid()),
        [code] nvarchar(20) NOT NULL,
        [libelle] nvarchar(100) NOT NULL,
        [is_active] bit NOT NULL CONSTRAINT [DF_contrats_types_is_active] DEFAULT ((1)),
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_types_created_at] DEFAULT (sysutcdatetime()),
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_types_updated_at] DEFAULT (sysutcdatetime()),
        [is_tarif_verrouille] bit NOT NULL CONSTRAINT [DF_contrats_types_is_tarif_verrouille] DEFAULT ((0)),
        CONSTRAINT [PK_contrats_types] PRIMARY KEY ([id]),
        CONSTRAINT [UQ_contrats_types_code] UNIQUE ([code])
    );
END
GO

-- =============================================================================
-- TABLE 3 : contrats
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_id] DEFAULT (newid()),
        [duree_mois] int NOT NULL,
        [date_expiration] AS (dateadd(day,(-1),dateadd(month,[duree_mois],[date_effet]))),
        [contrat_racine_id] uniqueidentifier NOT NULL,
        [contrat_precedent_id] uniqueidentifier NULL,
        [numero_avenant] int NOT NULL CONSTRAINT [DF_contrats_numero_avenant] DEFAULT ((0)),
        [objet_avenant] nvarchar(500) NULL,
        [is_current_used] bit NOT NULL CONSTRAINT [DF_contrats_is_current_used] DEFAULT ((1)),
        [is_regularisation] bit NOT NULL CONSTRAINT [DF_contrats_is_regularisation] DEFAULT ((0)),
        [service_gestionnaire] nvarchar(30) NOT NULL,
        [mode_passation] nvarchar(20) NOT NULL,
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_updated_at] DEFAULT (sysutcdatetime()),
        [numero_ao] nvarchar(50) NULL,
        [date_transmission_visa] date NULL,
        [numero_visa] nvarchar(50) NULL,
        [date_visa] date NULL,
        [observations_visa] nvarchar(1000) NULL,
        [date_signature_dg] date NULL,
        [signataire_egsa_nom] nvarchar(150) NULL,
        [signataire_egsa_fonction] nvarchar(150) NULL,
        [annee_enregistrement] char(4) NULL,
        [notification_client_effectuee] bit NOT NULL CONSTRAINT [DF_contrats_notification_client_effectuee] DEFAULT ((0)),
        [notification_client_date] date NULL,
        [date_lancement_ao] date NULL,
        [titre_convention] nvarchar(50) NOT NULL CONSTRAINT [DF_contrats_titre_convention] DEFAULT ('Occupation temporaire'),
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_created_at] DEFAULT (sysutcdatetime()),
        [alerte_expiration_traitee_par] nvarchar(100) NULL,
        [annee] char(4) NOT NULL,
        [numero_brouillon] int NOT NULL,
        [numero_officiel] nvarchar(100) NULL,
        [type_contrat_id] uniqueidentifier NOT NULL,
        [client_id] uniqueidentifier NOT NULL,
        [objet] nvarchar(500) NOT NULL,
        [client_signataire_nom] nvarchar(150) NULL,
        [client_signataire_fonction] nvarchar(150) NULL,
        [client_raison_sociale_snapshot] nvarchar(200) NULL,
        [client_nif_snapshot] nvarchar(50) NULL,
        [created_by] nvarchar(100) NOT NULL,
        [client_rc_snapshot] nvarchar(50) NULL,
        [date_creation] date NOT NULL CONSTRAINT [DF_contrats_date_creation] DEFAULT (CONVERT([date],sysutcdatetime())),
        [date_effet] date NULL,
        [periodicite_facturation] nvarchar(20) NOT NULL,
        [is_paiement_avance] bit NOT NULL CONSTRAINT [DF_contrats_is_paiement_avance] DEFAULT ((0)),
        [compte_bancaire_id] uniqueidentifier NULL,
        [taux_revision_annuel] decimal(5,2) NOT NULL CONSTRAINT [DF_contrats_taux_revision_annuel] DEFAULT ((0)),
        [devise] nvarchar(10) NOT NULL CONSTRAINT [DF_contrats_devise] DEFAULT ('DZD'),
        [taux_conversion] decimal(15,6) NOT NULL CONSTRAINT [DF_contrats_taux_conversion] DEFAULT ((1)),
        [is_facturation_bloquee] bit NOT NULL CONSTRAINT [DF_contrats_is_facturation_bloquee] DEFAULT ((0)),
        [statut] nvarchar(25) NOT NULL CONSTRAINT [DF_contrats_statut] DEFAULT ('BROUILLON'),
        [alerte_expiration_traitee_at] datetime2(7) NULL,
        [client_adresse_snapshot] nvarchar(300) NULL,
        [represente_par] nvarchar(200) NULL,
        [date_signature_client] date NULL,
        CONSTRAINT [PK_contrats] PRIMARY KEY ([id]),
        CONSTRAINT [UQ_contrats_brouillon] UNIQUE ([annee], [numero_brouillon])
    );
END
GO

-- =============================================================================
-- TABLE 4 : comptes_bancaires
-- =============================================================================
IF OBJECT_ID(N'dbo.comptes_bancaires', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[comptes_bancaires] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_comptes_bancaires_id] DEFAULT (newid()),
        [libelle] nvarchar(100) NOT NULL,
        [banque] nvarchar(150) NOT NULL,
        [agence] nvarchar(150) NOT NULL,
        [rib] nvarchar(255) NOT NULL,
        [is_active] bit NOT NULL CONSTRAINT [DF_comptes_bancaires_is_active] DEFAULT ((1)),
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_comptes_bancaires_created_at] DEFAULT (sysutcdatetime()),
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_comptes_bancaires_updated_at] DEFAULT (sysutcdatetime()),
        CONSTRAINT [PK_comptes_bancaires] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 5 : contrats_aeroports
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_aeroports', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_aeroports] (
        [id] uniqueidentifier NOT NULL,
        [contrat_id] uniqueidentifier NOT NULL,
        [aeroport_id] uniqueidentifier NOT NULL,
        [aeroport_nom_snapshot] varchar(150) NULL,
        [created_at] datetime2(7) NOT NULL,
        [updated_at] datetime2(7) NOT NULL,
        CONSTRAINT [PK__contrats__3213E83FDAE6BBD2] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 6 : contrats_biens
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_biens', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_biens] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_biens_id] DEFAULT (newid()),
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_biens_created_at] DEFAULT (sysutcdatetime()),
        [created_by] nvarchar(100) NOT NULL,
        [bien_designation_snapshot] nvarchar(200) NULL,
        [bien_code_snapshot] nvarchar(50) NULL,
        [date_pv_attribution] date NULL,
        [numero_pv_attribution] nvarchar(50) NULL,
        [commentaire] nvarchar(500) NULL,
        [objet_attribution] nvarchar(200) NULL,
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_biens_updated_at] DEFAULT (sysutcdatetime()),
        [nature_occupation] nvarchar(150) NULL,
        [taux_tva] decimal(5,2) NOT NULL CONSTRAINT [DF_contrats_biens_taux_tva] DEFAULT ((19)),
        [montant_forfaitaire] decimal(15,2) NULL,
        [tarif_commercial] decimal(15,2) NULL,
        [tarif_reference_lf] decimal(15,2) NULL,
        [surface_louee_m2] decimal(10,2) NULL,
        [mode_tarification] nvarchar(10) NOT NULL,
        [bien_id] uniqueidentifier NOT NULL,
        [contrat_id] uniqueidentifier NOT NULL,
        [zone] nvarchar(100) NULL,
        [grille_tarif_id] uniqueidentifier NULL,
        CONSTRAINT [PK_contrats_biens] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 7 : contrats_cautions
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_cautions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_cautions] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_cautions_id] DEFAULT (newid()),
        [contrat_id] uniqueidentifier NOT NULL,
        [type_caution] nvarchar(30) NOT NULL,
        [is_complement] bit NOT NULL CONSTRAINT [DF_contrats_cautions_is_complement] DEFAULT ((0)),
        [montant] decimal(15,2) NOT NULL,
        [reference] nvarchar(100) NULL,
        [date_caution] date NOT NULL,
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_cautions_created_at] DEFAULT (sysutcdatetime()),
        CONSTRAINT [PK_contrats_cautions] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 8 : contrats_envois
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_envois', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_envois] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_envois_id] DEFAULT (newid()),
        [contrat_id] uniqueidentifier NOT NULL,
        [numero_envoi] int NOT NULL,
        [date_envoi] date NOT NULL,
        [objet] nvarchar(300) NOT NULL,
        [date_rappel] date NULL,
        [date_retour_client] date NULL,
        [reponse_client] nvarchar(20) NULL,
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_envois_created_at] DEFAULT (sysutcdatetime()),
        CONSTRAINT [PK_contrats_envois] PRIMARY KEY ([id]),
        CONSTRAINT [UQ_contrats_envois] UNIQUE ([contrat_id], [numero_envoi])
    );
END
GO

-- =============================================================================
-- TABLE 9 : contrats_historique_statuts
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_historique_statuts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_historique_statuts] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_historique_statuts_id] DEFAULT (newid()),
        [contrat_id] uniqueidentifier NOT NULL,
        [statut] nvarchar(25) NOT NULL,
        [commentaire] nvarchar(1000) NULL,
        [date_effet] date NULL,
        [numero_decision] nvarchar(50) NULL,
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_historique_statuts_created_at] DEFAULT (sysutcdatetime()),
        CONSTRAINT [PK_contrats_historique_statuts] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 10 : contrats_rips
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_rips', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_rips] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_rips_id] DEFAULT (newid()),
        [contrat_id] uniqueidentifier NOT NULL,
        [rip] nvarchar(255) NOT NULL,
        [created_at] datetime NOT NULL CONSTRAINT [DF_contrats_rips_created_at] DEFAULT (getdate()),
        [updated_at] datetime NOT NULL CONSTRAINT [DF_contrats_rips_updated_at] DEFAULT (getdate()),
        CONSTRAINT [PK__contrats__3213E83FA796EB79] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 11 : contrats_services
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_services', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_services] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_services_id] DEFAULT (newid()),
        [contrat_id] uniqueidentifier NOT NULL,
        [mode_tarification] nvarchar(15) NOT NULL,
        [prix_unitaire] decimal(15,2) NULL,
        [unite_facturation] nvarchar(30) NULL,
        [montant_forfaitaire] decimal(15,2) NULL,
        [commentaire] nvarchar(500) NULL,
        [service_code_snapshot] nvarchar(20) NULL,
        [service_libelle_snapshot] nvarchar(200) NULL,
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_services_created_at] DEFAULT (sysutcdatetime()),
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_services_updated_at] DEFAULT (sysutcdatetime()),
        [catalogue_service_id] int NULL,
        CONSTRAINT [PK_contrats_services] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 12 : contrats_echeances
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_echeances] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_echeances_id] DEFAULT (newid()),
        [contrat_id] uniqueidentifier NOT NULL,
        [contrats_bien_id] uniqueidentifier NULL,
        [numero_echeance] int NOT NULL,
        [periode_debut] date NOT NULL,
        [periode_fin] date NOT NULL,
        [date_echeance] date NOT NULL,
        [is_active] bit NOT NULL CONSTRAINT [DF_contrats_echeances_is_active] DEFAULT ((1)),
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_echeances_created_at] DEFAULT (sysutcdatetime()),
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_echeances_updated_at] DEFAULT (sysutcdatetime()),
        [contrats_service_id] uniqueidentifier NULL,
        [annee_contrat] tinyint NOT NULL,
        CONSTRAINT [PK_contrats_echeances] PRIMARY KEY ([id])
    );
END
GO

-- =============================================================================
-- TABLE 13 : contrats_pieces_jointes
-- =============================================================================
IF OBJECT_ID(N'dbo.contrats_pieces_jointes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.[contrats_pieces_jointes] (
        [id] uniqueidentifier NOT NULL CONSTRAINT [DF_contrats_pieces_jointes_id] DEFAULT (newid()),
        [contrat_id] uniqueidentifier NOT NULL,
        [contrats_historique_statut_id] uniqueidentifier NULL,
        [type_document] nvarchar(30) NOT NULL,
        [nom_fichier] nvarchar(255) NOT NULL,
        [chemin_fichier] nvarchar(500) NOT NULL,
        [hash_fichier] char(64) NOT NULL,
        [type_mime] nvarchar(100) NOT NULL,
        [taille_octets] bigint NOT NULL,
        [created_by] nvarchar(100) NOT NULL,
        [created_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_pieces_jointes_created_at] DEFAULT (sysutcdatetime()),
        [updated_at] datetime2(7) NOT NULL CONSTRAINT [DF_contrats_pieces_jointes_updated_at] DEFAULT (sysutcdatetime()),
        CONSTRAINT [PK_contrats_pieces_jointes] PRIMARY KEY ([id]),
        CONSTRAINT [UQ_contrats_pj_hash] UNIQUE ([contrat_id], [hash_fichier])
    );
END
GO

-- FK FK_contrats_precedent
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_precedent' AND parent_object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    ALTER TABLE dbo.[contrats] WITH CHECK ADD CONSTRAINT [FK_contrats_precedent] FOREIGN KEY ([contrat_precedent_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats] CHECK CONSTRAINT [FK_contrats_precedent];
END
GO

-- FK FK_contrats_racine
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_racine' AND parent_object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    ALTER TABLE dbo.[contrats] WITH CHECK ADD CONSTRAINT [FK_contrats_racine] FOREIGN KEY ([contrat_racine_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats] CHECK CONSTRAINT [FK_contrats_racine];
END
GO

-- FK FK_contrats_type
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats_types', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_type' AND parent_object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    ALTER TABLE dbo.[contrats] WITH CHECK ADD CONSTRAINT [FK_contrats_type] FOREIGN KEY ([type_contrat_id]) REFERENCES dbo.[contrats_types] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats] CHECK CONSTRAINT [FK_contrats_type];
END
GO

-- FK FK_contrats_compte_bancaire
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.comptes_bancaires', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_compte_bancaire' AND parent_object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    ALTER TABLE dbo.[contrats] WITH CHECK ADD CONSTRAINT [FK_contrats_compte_bancaire] FOREIGN KEY ([compte_bancaire_id]) REFERENCES dbo.[comptes_bancaires] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats] CHECK CONSTRAINT [FK_contrats_compte_bancaire];
END
GO

-- FK FK_contrats_aeroports_contrats
IF OBJECT_ID(N'dbo.contrats_aeroports', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_aeroports_contrats' AND parent_object_id = OBJECT_ID(N'dbo.contrats_aeroports'))
BEGIN
    ALTER TABLE dbo.[contrats_aeroports] WITH CHECK ADD CONSTRAINT [FK_contrats_aeroports_contrats] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE CASCADE;
    ALTER TABLE dbo.[contrats_aeroports] CHECK CONSTRAINT [FK_contrats_aeroports_contrats];
END
GO

-- FK FK_contrats_biens_contrat
IF OBJECT_ID(N'dbo.contrats_biens', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_biens_contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_biens'))
BEGIN
    ALTER TABLE dbo.[contrats_biens] WITH CHECK ADD CONSTRAINT [FK_contrats_biens_contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_biens] CHECK CONSTRAINT [FK_contrats_biens_contrat];
END
GO

-- FK FK_contrats_cautions_contrat
IF OBJECT_ID(N'dbo.contrats_cautions', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_cautions_contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_cautions'))
BEGIN
    ALTER TABLE dbo.[contrats_cautions] WITH CHECK ADD CONSTRAINT [FK_contrats_cautions_contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_cautions] CHECK CONSTRAINT [FK_contrats_cautions_contrat];
END
GO

-- FK FK_contrats_envois_contrat
IF OBJECT_ID(N'dbo.contrats_envois', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_envois_contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_envois'))
BEGIN
    ALTER TABLE dbo.[contrats_envois] WITH CHECK ADD CONSTRAINT [FK_contrats_envois_contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_envois] CHECK CONSTRAINT [FK_contrats_envois_contrat];
END
GO

-- FK FK_contrats_hist_contrat
IF OBJECT_ID(N'dbo.contrats_historique_statuts', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_hist_contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_historique_statuts'))
BEGIN
    ALTER TABLE dbo.[contrats_historique_statuts] WITH CHECK ADD CONSTRAINT [FK_contrats_hist_contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_historique_statuts] CHECK CONSTRAINT [FK_contrats_hist_contrat];
END
GO

-- FK FK_ContratsRips_Contrat
IF OBJECT_ID(N'dbo.contrats_rips', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_ContratsRips_Contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_rips'))
BEGIN
    ALTER TABLE dbo.[contrats_rips] WITH CHECK ADD CONSTRAINT [FK_ContratsRips_Contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE CASCADE;
    ALTER TABLE dbo.[contrats_rips] CHECK CONSTRAINT [FK_ContratsRips_Contrat];
END
GO

-- FK FK_contrats_serv_contrat
IF OBJECT_ID(N'dbo.contrats_services', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_serv_contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_services'))
BEGIN
    ALTER TABLE dbo.[contrats_services] WITH CHECK ADD CONSTRAINT [FK_contrats_serv_contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_services] CHECK CONSTRAINT [FK_contrats_serv_contrat];
END
GO

-- FK FK_contrats_ech_bien
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats_biens', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_ech_bien' AND parent_object_id = OBJECT_ID(N'dbo.contrats_echeances'))
BEGIN
    ALTER TABLE dbo.[contrats_echeances] WITH CHECK ADD CONSTRAINT [FK_contrats_ech_bien] FOREIGN KEY ([contrats_bien_id]) REFERENCES dbo.[contrats_biens] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_echeances] CHECK CONSTRAINT [FK_contrats_ech_bien];
END
GO

-- FK FK_contrats_ech_contrat
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_ech_contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_echeances'))
BEGIN
    ALTER TABLE dbo.[contrats_echeances] WITH CHECK ADD CONSTRAINT [FK_contrats_ech_contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_echeances] CHECK CONSTRAINT [FK_contrats_ech_contrat];
END
GO

-- FK FK_contrats_ech_service
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats_services', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_ech_service' AND parent_object_id = OBJECT_ID(N'dbo.contrats_echeances'))
BEGIN
    ALTER TABLE dbo.[contrats_echeances] WITH CHECK ADD CONSTRAINT [FK_contrats_ech_service] FOREIGN KEY ([contrats_service_id]) REFERENCES dbo.[contrats_services] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_echeances] CHECK CONSTRAINT [FK_contrats_ech_service];
END
GO

-- FK FK_contrats_pj_contrat
IF OBJECT_ID(N'dbo.contrats_pieces_jointes', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_pj_contrat' AND parent_object_id = OBJECT_ID(N'dbo.contrats_pieces_jointes'))
BEGIN
    ALTER TABLE dbo.[contrats_pieces_jointes] WITH CHECK ADD CONSTRAINT [FK_contrats_pj_contrat] FOREIGN KEY ([contrat_id]) REFERENCES dbo.[contrats] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_pieces_jointes] CHECK CONSTRAINT [FK_contrats_pj_contrat];
END
GO

-- FK FK_contrats_pj_historique
IF OBJECT_ID(N'dbo.contrats_pieces_jointes', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.contrats_historique_statuts', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_contrats_pj_historique' AND parent_object_id = OBJECT_ID(N'dbo.contrats_pieces_jointes'))
BEGIN
    ALTER TABLE dbo.[contrats_pieces_jointes] WITH CHECK ADD CONSTRAINT [FK_contrats_pj_historique] FOREIGN KEY ([contrats_historique_statut_id]) REFERENCES dbo.[contrats_historique_statuts] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION;
    ALTER TABLE dbo.[contrats_pieces_jointes] CHECK CONSTRAINT [FK_contrats_pj_historique];
END
GO

-- INDEX IX_contrats_grille_type_national
IF OBJECT_ID(N'dbo.contrats_grille_tarifs', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_grille_type_national' AND object_id = OBJECT_ID(N'dbo.contrats_grille_tarifs'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_grille_type_national] ON dbo.[contrats_grille_tarifs] ([type_contrat_id], [is_national], [is_active]) INCLUDE ([libelle], [prix_unitaire_m2]);
END
GO

-- INDEX IX_contrats_types_actif
IF OBJECT_ID(N'dbo.contrats_types', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_types_actif' AND object_id = OBJECT_ID(N'dbo.contrats_types'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_types_actif] ON dbo.[contrats_types] ([is_active]) INCLUDE ([code], [is_tarif_verrouille], [libelle]);
END
GO

-- INDEX IX_contrats_client
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_client' AND object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_client] ON dbo.[contrats] ([client_id]);
END
GO

-- INDEX IX_contrats_compte_bancaire
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_compte_bancaire' AND object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_compte_bancaire] ON dbo.[contrats] ([compte_bancaire_id]);
END
GO

-- INDEX IX_contrats_expiration
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_expiration' AND object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_expiration] ON dbo.[contrats] ([date_expiration]) INCLUDE ([alerte_expiration_traitee_at], [statut]);
END
GO

-- INDEX IX_contrats_racine
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_racine' AND object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_racine] ON dbo.[contrats] ([contrat_racine_id], [numero_avenant]);
END
GO

-- INDEX UX_contrats_officiel
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL
BEGIN
    -- Remplace l'ancienne définition non filtrée sur les bases déjà migrées.
    -- Les brouillons sans numéro officiel ne doivent pas entrer dans cette unicité.
    IF EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE name = N'UX_contrats_officiel'
          AND object_id = OBJECT_ID(N'dbo.contrats')
          AND (
              is_unique = 0
              OR has_filter = 0
              OR REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                    UPPER(COALESCE(filter_definition, N'')),
                    N'[', N''), N']', N''), N'(', N''), N')', N''), N' ', N'')
                    <> N'NUMERO_OFFICIELISNOTNULL'
          )
    )
    BEGIN
        DROP INDEX [UX_contrats_officiel] ON dbo.[contrats];
    END

    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE name = N'UX_contrats_officiel'
          AND object_id = OBJECT_ID(N'dbo.contrats')
          AND is_unique = 1
          AND has_filter = 1
          AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                UPPER(COALESCE(filter_definition, N'')),
                N'[', N''), N']', N''), N'(', N''), N')', N''), N' ', N'')
                = N'NUMERO_OFFICIELISNOTNULL'
    )
    BEGIN
        CREATE UNIQUE NONCLUSTERED INDEX [UX_contrats_officiel]
            ON dbo.[contrats] ([annee], [numero_officiel], [numero_avenant])
            WHERE [numero_officiel] IS NOT NULL;
    END
END
GO

-- INDEX UX_contrats_racine_en_cours
IF OBJECT_ID(N'dbo.contrats', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_contrats_racine_en_cours' AND object_id = OBJECT_ID(N'dbo.contrats'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_contrats_racine_en_cours] ON dbo.[contrats] ([contrat_racine_id])
        WHERE ([statut]<>'OFFICIEL' AND [statut]<>'RESILIE' AND [statut]<>'ABANDONNE' AND [statut]<>'REFUSE_PAR_CLIENT');
END
GO

-- INDEX IX_contrats_biens_bien
IF OBJECT_ID(N'dbo.contrats_biens', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_biens_bien' AND object_id = OBJECT_ID(N'dbo.contrats_biens'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_biens_bien] ON dbo.[contrats_biens] ([bien_id]);
END
GO

-- INDEX IX_contrats_biens_contrat
IF OBJECT_ID(N'dbo.contrats_biens', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_biens_contrat' AND object_id = OBJECT_ID(N'dbo.contrats_biens'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_biens_contrat] ON dbo.[contrats_biens] ([contrat_id]);
END
GO

-- INDEX IX_contrats_cautions_contrat
IF OBJECT_ID(N'dbo.contrats_cautions', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_cautions_contrat' AND object_id = OBJECT_ID(N'dbo.contrats_cautions'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_cautions_contrat] ON dbo.[contrats_cautions] ([contrat_id]);
END
GO

-- INDEX IX_contrats_hist_contrat
IF OBJECT_ID(N'dbo.contrats_historique_statuts', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_hist_contrat' AND object_id = OBJECT_ID(N'dbo.contrats_historique_statuts'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_hist_contrat] ON dbo.[contrats_historique_statuts] ([contrat_id], [created_at]);
END
GO

-- INDEX IX_contrats_serv_contrat
IF OBJECT_ID(N'dbo.contrats_services', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_serv_contrat' AND object_id = OBJECT_ID(N'dbo.contrats_services'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_serv_contrat] ON dbo.[contrats_services] ([contrat_id]);
END
GO

-- INDEX IX_contrats_ech_contrat_date
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_ech_contrat_date' AND object_id = OBJECT_ID(N'dbo.contrats_echeances'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_ech_contrat_date] ON dbo.[contrats_echeances] ([contrat_id], [date_echeance]) INCLUDE ([contrats_bien_id], [contrats_service_id], [is_active], [numero_echeance]);
END
GO

-- INDEX IX_contrats_ech_service
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_ech_service' AND object_id = OBJECT_ID(N'dbo.contrats_echeances'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_ech_service] ON dbo.[contrats_echeances] ([contrats_service_id]);
END
GO

-- INDEX UX_contrats_ech_bien_numero
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_contrats_ech_bien_numero' AND object_id = OBJECT_ID(N'dbo.contrats_echeances'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_contrats_ech_bien_numero] ON dbo.[contrats_echeances] ([contrats_bien_id], [numero_echeance])
        WHERE ([contrats_bien_id] IS NOT NULL);
END
GO

-- INDEX UX_contrats_ech_service_numero
IF OBJECT_ID(N'dbo.contrats_echeances', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_contrats_ech_service_numero' AND object_id = OBJECT_ID(N'dbo.contrats_echeances'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_contrats_ech_service_numero] ON dbo.[contrats_echeances] ([contrats_service_id], [numero_echeance])
        WHERE ([contrats_service_id] IS NOT NULL);
END
GO

-- INDEX IX_contrats_pj_evenement
IF OBJECT_ID(N'dbo.contrats_pieces_jointes', N'U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_contrats_pj_evenement' AND object_id = OBJECT_ID(N'dbo.contrats_pieces_jointes'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_contrats_pj_evenement] ON dbo.[contrats_pieces_jointes] ([contrats_historique_statut_id]);
END
GO

