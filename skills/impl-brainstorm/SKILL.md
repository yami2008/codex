---
name: impl-brainstorm
description: Analyse et découpe une tâche d'implémentation avant toute modification applicative, sans imposer de séquence, de stack ou de langage.
---

# Brainstorm d'implémentation

Invocations acceptées :

```text
$impl-brainstorm <module> <feature ou périmètre> [tâche ou contexte]
$impl-brainstorm
```

L'invocation courte est valide en mode continuation uniquement si le module,
la Feature ou le périmètre et le contexte de travail sont déjà identifiables
sans ambiguïté dans la conversation ou les artefacts fiables. Elle ne doit pas
élargir le périmètre précédemment retenu.

**Garde d'entrée.** Si le module ou la Feature/le périmètre est absent,
ambigu ou contradictoire après cette résolution, indique précisément l'élément
manquant ou contradictoire, explique ce qu'il empêche de préparer et pose une
seule question ciblée. N'invente jamais une valeur pour éviter la question.
La syntaxe complète reste disponible comme aide :
`$impl-brainstorm <module> <feature ou périmètre> [tâche ou contexte]`.

Cette commande clarifie et prépare une tâche avant son implémentation.
Elle produit une proposition structurée dans la conversation.

Elle est indépendante du projet, du langage, de la stack, du framework, de
l'architecture, du SGBD et de toute autre commande. Elle ne code pas et ne
modifie pas le code, le schéma, la base, les migrations, les seeds ou le fichier
des tâches.

Elle peut mettre à jour `notes.<module>.md` lorsqu'une information durable,
utile et explicitement confirmée est rattachable sans ambiguïté au module.
L'absence de notes ne bloque pas le brainstorm. « Avant toute modification »
signifie donc avant toute modification applicative, de schéma, de données ou de
suivi de tâche.

## Règles absolues

- Toute information manquante, ambiguë ou contradictoire bloque l'étape concernée.
- Pose une seule question à la fois, explique le blocage et attends la réponse.
- Ne déduis jamais une règle métier, UX, technique ou d'architecture.
- Ne crée aucune fonctionnalité pour combler une zone d'ombre.
- Ne lance aucune autre commande, migration, seed, déploiement ou modification
  applicative.
- Ne transforme pas une proposition en décision sans validation explicite.
- Préserve les artefacts existants et leurs formats.

## 1. Cadrage de la demande

Le module, le périmètre, la fonctionnalité, la tâche et le résultat attendu
doivent être identifiables à partir de l'invocation, de la conversation ou des
documents fournis.

Si l'un de ces éléments manque ou peut recevoir plusieurs interprétations :

1. indique précisément le point bloquant ;
2. présente les options utiles lorsqu'elles existent ;
3. recommande une option avec sa raison ;
4. pose une seule question et attends la réponse.

Si plusieurs sources divergent, expose la contradiction avant de poursuivre.

## 2. Découverte ciblée

Localise les fichiers par leur nom et leur contenu réels, sans chemin imposé :

- règles et conventions applicables du projet ;
- `prd.md` ou la carte d'identité du projet lorsqu'elle existe, uniquement
  comme contexte global ;
- conventions de qualité ou de code, notamment un fichier `clean-code` ou son
  équivalent lorsqu'il est fourni ou désigné par le projet ;
- spécification, demande, critères d'acceptation ou artefact équivalent ;
- `notes.<module>.md` lorsqu'il existe ;
- fichier de tâches lorsqu'il est fourni ou trouvé ;
- schéma ou structures persistées si la tâche concerne des données ;
- code, composants, services, interfaces, ressources et tests concernés ;
- scénarios ou contrats de comportement lorsqu'ils existent.

Les fichiers de tâches, scénarios, tests, templates et scripts sont facultatifs.
Signale leur absence lorsqu'ils ont été recherchés. Leur absence ne bloque pas
le brainstorm si le besoin et le résultat attendu sont suffisamment clairs.
Si l'un d'eux devient nécessaire à une décision, arrête-toi à ce moment et
demande comment poursuivre.

Si un fichier est indispensable à une décision ou à une vérification :

1. indique son nom logique et les chemins testés ;
2. explique ce que son absence empêche de déterminer ;
3. demande s'il faut le fournir, le créer ou poursuivre sans lui ;
4. attends la décision.

Pour chaque source recherchée, indique si elle a été trouvée et lue, si elle
est absente, ou si elle est illisible. Une source optionnelle absente ne bloque
pas ; une source explicitement requise par le projet ou nécessaire à une
décision bloque jusqu'à clarification.

Si une information durable, utile et confirmée doit être conservée dans
`notes.<module>.md` :

- mets le fichier à jour lorsqu'il existe ;
- crée-le si le dossier du module et le nommage sont identifiables sans ambiguïté ;
- si son emplacement reste ambigu, signale que l'information ne sera pas
  persistée et demande une précision uniquement si cette persistance est
  nécessaire ;
- ne persiste aucune interprétation non validée.

## 3. Compréhension

Présente séparément :

- les éléments confirmés ;
- le résultat attendu ;
- le périmètre inclus et exclu ;
- les surfaces et artefacts concernés ;
- les dépendances connues ;
- les états de succès et d'erreur pertinents ;
- les décisions encore ouvertes ;
- les risques et limites.

Ne complète pas silencieusement une information absente.

## 4. Découpage proposé

Propose une tâche ou un groupe cohérent à la fois.
Chaque proposition indique :

- un identifiant stable ;
- l'objectif ;
- les éléments concernés ;
- les prérequis ;
- le résultat vérifiable ;
- les contrôles ou preuves attendus ;
- les risques et dépendances.

Les critères, scénarios ou tests existants peuvent être associés lorsqu'ils
existent. Ils ne sont jamais obligatoires et aucun nouveau fichier de scénarios
n'est créé par cette commande.

Si le découpage dépend d'une décision non tranchée, arrête la proposition à ce
point et pose la question correspondante.

## 5. Analyse des données et dépendances

Si la tâche touche à des données persistées :

- compare les artefacts BDD disponibles avec le besoin ;
- signale tout écart de table, colonne, relation, contrainte, index, type,
  nullabilité, migration ou donnée de référence ;
- ne choisis pas la correction au hasard ;
- si un écart est détecté, arrête le brainstorm à ce point ;
- explique l'écart, son impact et les artefacts concernés ;
- indique qu'une synchronisation BDD distincte est nécessaire ;
- propose `$db-sync <module>` comme traitement séparé ;
- ne lance jamais `$db-sync` automatiquement ;
- attends la décision explicite avant de poursuivre.

Si aucun écart BDD n'est détecté, poursuis normalement l'analyse de la tâche.
La mention de `$db-sync` est un handoff conditionnel : elle ne transforme pas
cette commande en dépendance obligatoire et ne l'empêche pas de fonctionner de
manière autonome.

Si un handoff vers `$db-sync` devient nécessaire mais que cette commande est
indisponible ou illisible, signale précisément cette limite et arrête l'étape
BDD concernée. Ne prétends pas avoir transmis le dossier et ne remplace pas la
synchronisation par une modification improvisée.

Pour les dépendances externes ou entre composants, précise ce qui est confirmé,
ce qui doit être disponible et ce qui reste à décider. Si une dépendance est
nécessaire pour trancher le périmètre ou le comportement, son absence bloque et
doit faire l'objet d'une question. Si elle ne concerne que l'implémentation
ultérieure, indique-la comme prérequis sans bloquer le brainstorm.

## 6. Discussion et validation

Pour chaque point incertain :

1. expose le problème ;
2. présente les options utiles ;
3. donne une recommandation lorsqu'elle est justifiée ;
4. pose une seule question ;
5. attends la réponse avant de continuer.

À la fin :

- résume le périmètre retenu ;
- liste les tâches dans leur ordre proposé ;
- rappelle les décisions prises ;
- rappelle les impacts BDD, dépendances, risques et limites ;
- liste les questions restantes ;
- demande la validation explicite de la proposition.

La validation concerne le plan présenté uniquement. Elle n'autorise pas une
modification du code, du schéma, de la base ou du fichier des tâches.

## Compte rendu

Le compte rendu indique :

- contexte et périmètre analysés ;
- sources réellement lues ;
- éléments confirmés et hypothèses refusées ;
- tâches proposées et ordre recommandé ;
- critères ou preuves associés lorsqu'ils existent ;
- décisions prises et informations en attente ;
- règles ajoutées aux notes, le cas échéant ;
- écarts BDD et dépendances ;
- prochaine action attendue, sans lancer une autre commande.
