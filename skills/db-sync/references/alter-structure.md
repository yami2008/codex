# Gabarit d'un artefact de rattrapage de structure

Structure de référence du script de rattrapage des bases **déjà créées et peuplées**.

Les noms `alter.<module>.sql` et les exemples SQL ci-dessous sont illustratifs.
Ils ne sont applicables que si le projet déclare ce format et ce langage.
Pour un autre SGBD ou format, conserve les invariants et adapte la syntaxe selon
les conventions documentées du projet.

Ce gabarit est **portable** : la stratégie d'exécution et la syntaxe se déduisent
du moteur et de l'outil de migration documentés par le projet.

---

## Ce qu'un `alter` est, et ce qu'il n'est pas

| | Artefact d'initialisation | Artefact de rattrapage |
|---|---|---|
| Cible | base **vierge** | base **déjà peuplée** |
| Rôle | build complet du module | passage d'une version à la suivante |
| Contenu | structure complète attendue | uniquement le **delta** |
| Données existantes | il n'y en a pas | à préserver, backfill compris |

Ne mélange jamais l'initialisation complète et le rattrapage incrémental, sauf
si la convention explicitement déclarée du projet impose un autre modèle.

---

## Les deux décisions non négociables

### 1. Modèle de rejeu

Détermine d'abord comment le projet exécute et trace ses migrations.

- **Script autonome susceptible d'être relancé** : rends chaque étape idempotente
  lorsque le moteur le permet et vérifie l'état avant d'agir.
- **Migration versionnée exécutée une seule fois par un outil** : respecte le
  mécanisme de version, d'ordre et de verrouillage de cet outil ; n'ajoute pas de
  gardes qui masqueraient une dérive de schéma.

Si le modèle de rejeu n'est pas documenté, arrête-toi et demande lequel appliquer.

### 2. Aucune perte de donnée utile

Passer une colonne en `NOT NULL` sur une table peuplée peut échouer ou rendre des
lignes existantes invalides. Une stratégie sûre courante est :

    1. ajouter la colonne en NULL
    2. backfill — remplir les lignes existantes
    3. passer la colonne en NOT NULL

Quand le backfill n'a pas de source évidente, arrête-toi et demande la règle
métier ou la valeur de repli ; ne la choisis jamais au hasard.

---

## Le plan, dans l'ordre

    Contexte : <stockage déjà peuplé, version source et version cible>
    Périmètre : <delta exact, sans éléments hors périmètre>
    Garanties : <modèle de rejeu, préservation des données, compatibilité>
    Exécution : <commande ou mécanisme réellement déclaré par le projet>

    Étape N — <titre>
    Rejeu ou garde : <mécanisme versionné ou condition d'idempotence validé>
    Action : <modification dans le format du projet>
    Vérification : <preuve observable que l'étape a abouti>

    Récapitulatif : <une vérification par changement attendu>

Pour un projet SQL, ces éléments peuvent prendre la forme de commentaires,
requêtes et gardes SQL. Pour tout autre format, conserve le même ordre et les
mêmes garanties avec la syntaxe documentée du projet.

---

## Le récapitulatif de fin — obligatoire

L'artefact se termine par un mécanisme de vérification adapté au projet, qui
établit **OK** ou **KO** pour chaque changement attendu : structure présente,
contrainte appliquée, élément supprimé ou donnée de référence attendue.

C'est ce qui permet de savoir en un coup d'œil, sur un poste donné, si le rattrapage est réellement passé —\
sans relire le script ni interroger le schéma à la main.

Vérifie aussi bien les ajouts que les **suppressions attendues**.

---

## Détails qui comptent

- **Une trace vérifiable par étape réellement exécutée**, lorsque le format le
  permet. Sinon, le compte rendu de la commande doit indiquer la vérification
  réellement effectuée.
- **Ordre imposé** : supprimer les contraintes qui portent sur une colonne **avant** de supprimer la colonne.
- Pour un index dont la définition change, utilise l'opération supportée et
  recommandée par le moteur ; si elle exige suppression puis création, protège
  l'ordre selon le modèle de rejeu retenu.
- **Renommer plutôt que supprimer/recréer** quand une colonne change seulement de nom : le contenu est préservé.
- Le contenu d'un alter **varie entièrement selon ce qui a changé**. Ce gabarit fixe le cadre et les garanties,\
  jamais une liste d'étapes à recopier.
- Des commentaires courts, avec la syntaxe du format déclaré par le projet ; une
  idée par ligne.
