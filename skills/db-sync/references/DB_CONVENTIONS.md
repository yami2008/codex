# Conventions communes de la synchronisation BDD

Règles communes au skill `$db-sync`.
Une commande qui référence ce fichier l'applique avant sa propre section « Fichiers à charger ».

Ce fichier est spécifique à l'exécution Codex.
Il est indépendant d'un projet, d'une stack et d'un langage de programmation.
Le SGBD est déterminé par le projet ou fourni explicitement par l'utilisateur.
Cette référence fournit des invariants génériques. Son absence bloque la
commande : elle doit signaler la référence indisponible avant toute
comparaison, conception ou écriture.

---

## 0. Aucune décision silencieuse

Dès qu'un élément est ambigu, incomplet, contradictoire ou sujet à plusieurs interprétations — métier, périmètre, structure, type, contrainte ou SGBD — arrête la sous-étape concernée.

Pose une seule question à la fois :

1. formule précisément le point incertain ;
2. propose les options plausibles ;
3. indique ta recommandation et sa raison ;
4. attends la réponse avant de concevoir, écrire ou corriger.

Ne transforme jamais une convention supposée en décision validée.

---

## 1. Localisation des artefacts

Les artefacts peuvent être organisés différemment selon le projet.
Ne présume jamais leur chemin.

1. Localise le dossier du module avec `rg --files`.
2. Teste le singulier et le pluriel du nom du module.
3. Liste le contenu réel du dossier trouvé.
4. Réutilise le suffixe réellement présent pour chaque artefact.
5. N'écris jamais un doublon à côté d'un fichier équivalent.

Les artefacts principaux de cette phase sont :

- `schema.<module>.md` ;
- `migration.<module>.<extension>` lorsque le SGBD possède un langage de migration exploitable ;
- `draft.<module>.md` pendant une session interrompue.

Les fichiers `notes.<module>.md` et `features.<module>.txt` sont des sources métier importantes.
Ils ne sont pas recréés silencieusement.

Si aucun dossier de module n'existe, propose un emplacement cohérent avec les
dossiers voisins et attends l'accord avant de le créer.
Si plusieurs dossiers ou suffixes sont possibles, liste-les, recommande le plus
cohérent et attends le choix avant toute lecture faisant foi ou toute écriture.

---

## 2. Fichiers projet absents — arrêt jusqu'à décision

Tout fichier d'entrée recherché par une étape doit être signalé s'il est absent.

- Une entrée **obligatoire** manquante arrête l'étape jusqu'à la décision de
  l'utilisateur.
- Une entrée **conditionnelle** manque uniquement si sa condition s'applique.
- Une entrée **optionnelle** absente est signalée sans bloquer tant qu'aucune
  décision n'en dépend.
- Une sortie qui n'existe pas encore n'est pas un fichier manquant.

Si une entrée optionnelle devient nécessaire à une décision, arrête l'étape à
ce moment et demande comment poursuivre.

Les fichiers suivants ne sont pas tous requis simultanément. Leur statut dépend
de l'écart et de l'artefact à produire :

- `AGENTS.md` ou un fichier de règles équivalent est requis lorsque le projet en
  désigne un comme source d'instructions ;
- la conception validée, la documentation métier ou un équivalent est requise
  pour concevoir ou modifier une structure ;
- le moteur de stockage et le modèle de rejeu sont requis pour produire un
  artefact exécutable ;
- `prd.md`, `notes.<module>.md`, `features.<module>.txt`, les scénarios et les
  spécimens sont optionnels tant qu'aucune décision n'en dépend.

Signale chaque fichier absent et son statut.
Explique ce que cette absence peut faire perdre comme contexte ou comme convention.

Pour une absence bloquante, propose ensuite :

1. créer l'artefact avec un gabarit adapté ;
2. continuer directement sans cet artefact pour la session.

Attends le choix de l'utilisateur avant de créer le fichier ou de poursuivre sans lui.
Continuer sans le fichier constitue une autorisation explicite pour la session.
La commande doit alors signaler l'angle mort créé par cette absence.

Si un artefact est indispensable à une sortie précise, explique cette limite.
Par exemple, une migration fiable ne peut pas être produite sans schéma validé.

`draft.<module>.md` absent lors d'un premier passage est normal :
il ne constitue pas un fichier d'entrée manquant et peut être créé si la reprise persistante est choisie.

Après chaque arrêt, pose une seule question et attends la réponse avant de poursuivre.

---

## 3. Identification du SGBD

Le SGBD doit être identifié avant la conception des tables.
Les types, contraintes particulières et migrations dépendent de lui.

Cherche d'abord l'information dans les fichiers du projet, notamment `prd.md` ou le fichier que le projet désigne.

Si le SGBD n'est pas trouvé, ne l'invente pas.
Demande-le avant de proposer la première table.

Le langage, l'extension et le mécanisme d'exécution de la migration sont
déterminés par le projet ou fournis explicitement par l'utilisateur. Le SGBD ne
suffit pas à les déduire. Si le format de rejeu n'est pas identifiable, arrête-
toi avant de produire l'artefact et demande-le.

---

## 4. Conventions BDD du projet

Si le projet fournit des conventions BDD, elles sont prioritaires.
Localise-les par nom et lis-les avant la première table.

Si elles n'existent pas :

1. signale leur absence ;
2. propose un jeu de conventions générique ;
3. demande l'accord avant de l'appliquer à la conception.

Le jeu générique ne devient jamais une vérité silencieuse.

La proposition générique couvre au minimum :

- la langue et la casse des tables, colonnes, contraintes et index ;
- la stratégie d'identifiant et la compatibilité des clés ;
- les règles de nullabilité et de valeur par défaut ;
- le traitement des dates, heures et fuseaux ;
- la suppression, la désactivation et l'historisation ;
- le nommage des relations, contraintes et index ;
- les champs techniques éventuels et leur source.

Chaque choix reste une proposition jusqu'à validation explicite.

---

## 5. Conception de la structure

Chaque décision de structure doit être reliée à une fonctionnalité ou à une règle métier connue.

Ne crée pas une table, une colonne, une relation ou un index uniquement parce qu'il pourrait servir plus tard.

Le schéma utilise uniquement les types réels du SGBD identifié.
Il distingue la garantie portée par la base de celle qui reste applicative.

Une référence entre deux contextes dont la nature n'est pas établie doit être signalée.
Ne choisis pas silencieusement entre FK réelle et référence logique.

---

## 6. Snapshots

Chaque champ susceptible d'être figé doit faire l'objet d'une justification champ par champ.

Un snapshot est justifié lorsqu'une valeur doit rester fidèle à un instant donné, notamment pour un document légal ou une donnée historique.

Un snapshot inutile est une duplication dangereuse.
L'absence de snapshot doit également être justifiée lorsqu'une source peut être modifiée.

---

## 7. Reprise et écriture

Le brouillon contient la phase courante, les tables validées et les questions ouvertes.

Relis-le avant de reprendre.
Ne repose pas une question déjà tranchée.

Les écritures autorisées par cette phase sont :

- `draft.<module>.md` pour la reprise ;
- `schema.<module>.md` après validation ;
- la migration après validation du schéma et identification du SGBD ;
- l'artefact `alter` ou de synchronisation après approbation de l'écart ;
- le `seed` après approbation lorsqu'une donnée de référence ou d'essai est
  nécessaire ;
- `notes.<module>.md` lorsqu'une information durable, utile et explicitement
  confirmée est identifiée.

Ne modifie pas une feature ou une règle au hasard pour résoudre un problème de schéma.

### Règle durable découverte en cours de commande

Toute commande BDD peut enrichir `notes.<module>.md` lorsqu'elle reçoit une
information durable, utile ou une contrainte durable **explicitement confirmée**
et rattachable sans ambiguïté au module courant.

- Si le fichier existe, ajoute l'information dans la section adaptée et indique
  ce qui a été écrit.
- S'il manque et que son emplacement est identifiable, crée-le avec le nommage
  déjà utilisé par le module.
- Si son emplacement est ambigu, signale que l'information ne sera pas
  persistée et demande une précision uniquement si cette persistance est
  nécessaire.
- N'écris jamais une hypothèse, une interprétation ou une décision encore
  ouverte dans les notes.

---

## 8. Mise en forme

Une idée par ligne.
Les phrases restent complètes et courtes.

Dans les fichiers Markdown, utilise `\` pour conserver les retours à la ligne lorsque nécessaire.
Dans les tableaux Markdown, garde les cellules courtes et n'utilise pas `\`.

Cette règle s'applique aussi aux réponses et aux artefacts produits par la phase.

