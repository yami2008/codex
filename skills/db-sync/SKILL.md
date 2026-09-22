---
name: db-sync
description: Analyse un écart BDD puis, après approbation explicite, synchronise les artefacts concernés sans imposer de séquence, de stack ou de langage particulier.
---

# Synchronisation BDD

Invocation : `$db-sync <module>`

**Garde d'argument.** Si `<module>` est vide, arrête-toi immédiatement, affiche
`BLOQUÉ — aucun module fourni. Usage : $db-sync <module>` et attends.
Ne devine pas le module.

Avant toute recherche, localise les conventions BDD déclarées par le projet.
La référence générique fournie avec cette skill est obligatoire : lis
[DB_CONVENTIONS.md](references/DB_CONVENTIONS.md) pour ses invariants génériques,
puis recherche un éventuel `DB_CONVENTIONS.md` propre au projet. L'absence de
cette référence générique arrête la commande ; signale le chemin testé et
demande de la fournir avant de poursuivre.
Si une convention propre au projet est trouvée, lis-la et applique-la. Si elle
est absente, signale-le ; arrête-toi uniquement lorsqu'une décision de
conception, de format ou de rejeu dépend de cette convention. Dans ce cas,
demande s'il faut la fournir, en créer une ou poursuivre explicitement avec une
proposition générique.

Cette commande traite un écart entre la conception BDD validée et la structure,
la donnée de référence ou le script nécessaire à une évolution.

Elle peut recevoir le contexte préparé par `$impl-code` : module, écart observé,
sources comparées et artefacts concernés. Ce contexte accélère l'analyse mais ne
remplace jamais la vérification des sources réelles du projet.

Lorsqu'elle est proposée par `$impl-code`, elle constitue une étape séparée :
elle ne reprend l'écriture qu'après l'approbation explicite de l'écart et ne
relance jamais automatiquement `$impl-code`.

Elle est indépendante du projet, du langage, du framework et de l'architecture.
Elle s'adapte uniquement aux sources, au moteur de stockage et aux formats
explicitement déclarés par le projet ou fournis par l'utilisateur.

Elle ne modifie pas une base réelle par défaut. Elle modifie uniquement les
artefacts approuvés, un écart à la fois.

## Règles absolues

- Toute information manquante, ambiguë ou contradictoire bloque l'étape concernée.
- Pose une seule question à la fois, explique le blocage et attends la réponse.
- Ne prends aucune décision de conception, de données ou de métier au hasard.
- Présente un seul écart à la fois.
- Aucune écriture d'artefact avant l'approbation explicite de l'écart.
- N'exécute aucune migration, aucun seed et aucune écriture directe en base sans
  demande distincte et explicite.
- Ne modifie pas le code applicatif sauf demande explicite.
- Ne lance pas une autre commande pour contourner une information manquante.

## 1. Entrée et contexte

Le module doit être identifiable. Le besoin de synchronisation peut venir de la
demande, d'une tâche, d'un diagnostic de code, d'un modèle, d'une entité, d'une
structure SQL ou d'un autre artefact explicitement fourni.

Si le module, l'élément concerné ou le besoin attendu est ambigu, arrête-toi et
demande une clarification avant toute comparaison.

## 2. Fichiers à localiser

Recherche par leur nom et leur contenu réels, sans chemin imposé :

- `prd.md` ou la carte d'identité du projet pour le contexte global, lorsqu'il
  existe ;
- `schema.<module>.md` ou l'artefact de conception équivalent ;
- l'artefact de création, migration ou synchronisation déclaré par le projet ;
- les modèles, entités ou structures de données concernés ;
- les artefacts `alter` et `seed` lorsqu'ils sont applicables ;
- `notes.<module>.md` lorsqu'il existe ;
- les conventions BDD ou formats explicitement déclarés par le projet.

Ces références n'ont pas toutes le même statut. Pour un diagnostic, le module
et le besoin ou l'écart à comparer sont indispensables. Pour produire un
artefact, la conception validée ou son équivalent, le moteur de stockage et le
format de rejeu sont indispensables. Les notes, features, scénarios, templates
et scripts auxiliaires restent optionnels tant qu'aucune décision n'en dépend.
Une référence absente est signalée avec ce statut précis.

Lorsque ces références existent et que le périmètre le justifie, consulte-les
avant de produire les artefacts concernés :

- [alter-structure.md](references/alter-structure.md) pour les écarts de
  structure sur une base déjà existante ;
- [seed-structure.md](references/seed-structure.md) pour les données de
  référence ou jeux d'essai.

Si l'artefact à produire nécessite l'un de ces gabarits et que le fichier est
absent ou illisible, arrête la production de cet artefact, indique le chemin
testé et demande s'il faut le fournir ou poursuivre avec une structure
explicitement validée. Ne remplace pas silencieusement un gabarit manquant par
une structure inventée.

Ces références exposent des invariants et des exemples. Elles ne remplacent pas
le format déclaré par le projet et ne doivent pas imposer SQL, un nom de fichier,
un moteur de stockage ou une organisation particulière.

Un fichier de tests ou de scénarios n'est pas requis par cette commande. S'il
existe et apporte un contexte utile, il peut être consulté sans être modifié.

Le moteur de stockage ou le SGBD doit être identifié dans les sources du projet
ou dans la demande. Le format attendu de chaque artefact à modifier doit aussi
être identifiable.

Si un fichier indispensable, le moteur de stockage ou le format manque :

1. indique le nom logique et les chemins testés ;
2. explique ce que l'absence empêche de comparer ou de produire ;
3. propose de le fournir, de le créer ou de poursuivre sans lui lorsque cela est
   réellement possible ;
4. attends la décision.

Pour chaque source recherchée, indique si elle a été trouvée et lue, si elle
est absente, ou si elle est illisible. Une source optionnelle absente est
signalée sans bloquer ; une source nécessaire à la comparaison, à la
conception, au format ou au rejeu bloque l'étape concernée.

## 3. Diagnostic sans écriture

Compare la conception validée avec le besoin réel et les artefacts existants.
Ne traite qu'un écart à la fois et présente-le ainsi :

```text
Écart N : <titre>
Élément concerné : <table, colonne, relation, contrainte ou donnée>
Prévu : <conception validée>
Nécessaire : <besoin découvert>
Origine : <conception, implémentation, donnée ou traduction>
Impact : <bloquant, dette, compatibilité ou autre>
Migration de données : <oui, non ou à déterminer>
Conséquence hors module : <détail ou aucune>
Proposition : <correction proposée>
```

Si l'écart révèle une règle métier durable, signale-la dans la proposition sans
écrire dans les notes à ce stade. Elle ne pourra être persistée qu'après
l'approbation de l'écart et la confirmation explicite de la règle.

## 4. Validation de l'écart

Demande si l'utilisateur approuve ou refuse l'écart présenté.
Ne passe pas à un autre écart avant sa réponse.

Pour un écart approuvé, confirme précisément les artefacts qui seront modifiés,
le format utilisé, les garanties attendues et l'impact sur les données.

Si une information durable, utile et confirmée a été reçue :

- mets à jour `notes.<module>.md` lorsqu'il existe ;
- crée-le si le dossier du module et le nommage sont identifiables sans ambiguïté ;
- si son emplacement reste ambigu, signale que l'information ne sera pas
  persistée et demande une précision uniquement si cette persistance est
  nécessaire ;
- ne persiste aucune interprétation non confirmée.

Si le changement a un effet observable, indique les critères ou vérifications
qui devraient être ajoutés ou rejoués. Cette information reste facultative et
ne crée aucun fichier de tests depuis cette commande.

## 5. Application de l'écart approuvé

Pour chaque écart approuvé, et uniquement celui-ci :

1. mets à jour l'artefact de conception si la conception est concernée ;
2. mets à jour l'artefact de création, de migration ou de synchronisation si le
   format et le modèle de rejeu du projet l'exigent ;
3. produis ou mets à jour l'artefact de rattrapage uniquement lorsqu'une base
   existante doit être synchronisée ;
4. complète un seed uniquement si des données de référence ou d'essai sont
   nécessaires et que cette écriture est approuvée ;
5. ne crée pas d'artefact non applicable à l'écart ;
6. vérifie la cohérence avec les modèles ou structures concernés ;
7. relis les artefacts modifiés.

Respecte les gabarits réellement utilisés par le projet. Un artefact de
rattrapage destiné à une base existante doit suivre le modèle de rejeu documenté
par le projet et préserver les données utiles. S'il s'agit d'un script autonome
rejouable, rends-le idempotent lorsque le moteur le permet. S'il s'agit d'une
migration versionnée, respecte le mécanisme d'exécution unique de l'outil.

Si l'utilisateur demande aussi l'exécution d'une migration ou d'un seed, vérifie
d'abord le mécanisme, la cible, le profil, la commande exacte et l'autorisation
associée dans les sources du projet. Si l'un de ces éléments manque ou est
ambigu, arrête-toi et pose une question. N'invente jamais une connexion, une
cible ou une commande d'exécution. Après une exécution autorisée, rapporte le
résultat réel sans afficher de secret.

## 6. Vérification et compte rendu

Vérifie statiquement la cohérence, le modèle de rejeu ou les gardes
d'idempotence applicables, l'ordre des opérations, la préservation des données
et la conformité au moteur de stockage déclaré.

Le compte rendu indique :

- écarts approuvés, refusés et en attente ;
- fichiers modifiés avec leurs chemins réels ;
- moteur de stockage et formats utilisés ;
- migration de données nécessaire ou non ;
- critères ou vérifications proposés, lorsqu'ils existent ;
- règles ajoutées aux notes, le cas échéant ;
- contrôles réalisés et résultats ;
- prochaine décision attendue.

Cette commande ne déclare pas une implémentation applicative terminée et ne
modifie pas le code pour masquer l'écart BDD.
