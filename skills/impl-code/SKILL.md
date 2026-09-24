---
name: impl-code
description: Implémente une tâche explicitement définie et fournit une vérification réexécutable adaptée.
---

# Implémentation ciblée

Invocations acceptées :

```text
$impl-code <module> <feature ou périmètre> <tâche ou lot de tâches>
$impl-code
```

Les trois éléments restent obligatoires pour définir le périmètre, mais ils
peuvent être résolus depuis plusieurs sources fiables, dans cet ordre :

1. l'invocation courante ;
2. la conversation courante, notamment la demande précédente, le diagnostic
   déjà validé et les consignes explicites de démarrage ou de continuation ;
3. les artefacts fiables du projet.

L'invocation courte `$impl-code` est donc valide en mode continuation lorsque
le module, la Feature/le périmètre et la tâche ou le lot ont déjà été définis
sans ambiguïté. Une consigne telle que « commence l'exécution » ou « poursuis »
autorise alors l'implémentation du périmètre déjà validé ; elle n'élargit pas
ce périmètre.

**Garde d'entrée.** Si le module, la Feature/le périmètre ou la tâche est absent,
ambigu ou contradictoire après cette résolution, n'affiche pas uniquement la
syntaxe générique. Indique précisément l'élément manquant ou contradictoire,
explique ce qu'il empêche d'implémenter et pose une seule question ciblée.
N'invente jamais une valeur pour éviter la question. La syntaxe complète reste
disponible comme aide :
`$impl-code <module> <feature ou périmètre> <tâche ou lot de tâches>`.

Cette commande implémente uniquement le périmètre explicitement défini par
l'utilisateur ou par les artefacts fiables du projet.

Une fois le périmètre suffisamment défini et l'autorisation de démarrer
présente, la finalité de la commande est d'implémenter l'ensemble de la
fonctionnalité ou du lot demandé, pas seulement d'en faire l'analyse. Elle
peut découper le travail en tranches techniques pour sécuriser l'exécution,
mais poursuit automatiquement les tranches qui ne nécessitent aucune décision
supplémentaire. Elle s'arrête uniquement lorsqu'une information, une décision
ou une autorisation réellement nécessaire manque.

Elle est indépendante du projet, du langage, de la stack, du framework, du SGBD
et de l'organisation du dépôt. Elle s'adapte aux fichiers, outils et contrôles
réellement déclarés par le projet.

Elle ne force pas l'utilisation d'une autre skill et ne lance pas une autre
commande pour combler une information manquante.

## Règles absolues

- Toute information manquante, ambiguë ou contradictoire bloque l'étape concernée.
- Pose une seule question à la fois, explique le blocage et attends la réponse.
- Ne prends aucune décision métier, UX, technique ou d'architecture au hasard.
- N'ajoute aucune fonctionnalité hors du périmètre validé.
- Ne réorganise pas et ne modifie pas automatiquement le fichier des tâches.
- Préserve les changements existants et les fichiers hors périmètre.
- N'exécute aucune migration, seed, écriture directe en base ou action destructive
  sans demande explicite.
- N'exécute pas automatiquement une autre commande ou skill.
- Signale le résultat de chaque tranche avant de poursuivre ; ce compte rendu
  de progression ne constitue pas une demande d'autorisation supplémentaire
  lorsque le périmètre est déjà explicite.

## 1. Entrée et périmètre

Fusionne uniquement le contexte fourni par l'invocation, la conversation et les
documents explicitement pertinents du projet. En mode continuation, réutilise
le dernier périmètre explicitement validé tant qu'aucune instruction plus
récente ne le remplace.

Avant d'écrire, établis la fiche de périmètre suivante :

- module concerné ;
- Feature ou périmètre ;
- tâche ou lot de tâches ;
- résultat attendu ;
- limites connues ;
- autorisation de démarrer.

Une consigne courte de démarrage est suffisante si cette fiche est déjà
complète dans la conversation ou les artefacts fiables. Ne demande pas à
l'utilisateur de répéter ces éléments par simple formalisme.

Le module, la fonctionnalité, la tâche, le résultat attendu et les limites
doivent être identifiables. Si l'un de ces éléments est absent ou interprétable,
arrête-toi et demande une clarification ciblée, une seule question à la fois.

Si plusieurs sources divergent :

1. expose précisément la contradiction ;
2. présente les choix possibles ;
3. recommande une option si une raison objective existe ;
4. attends la décision avant d'écrire ou d'exécuter quoi que ce soit.

## 2. Découverte ciblée

Localise les fichiers par leur nom réel et leur contenu, sans chemin imposé :

- règles et conventions applicables du projet ;
- `prd.md` ou la carte d'identité du projet lorsqu'elle existe, uniquement
  comme contexte global ;
- conventions de qualité ou de code, notamment un fichier `clean-code` ou son
  équivalent lorsqu'il est fourni ou désigné par le projet ;
- spécification de la tâche, critères d'acceptation ou artefact équivalent ;
- code, composants, services, interfaces, tests et ressources concernés ;
- `notes.<module>.md` lorsqu'il existe ;
- schéma, migrations, seeds ou structures persistées uniquement si la tâche
  concerne des données ;
- tâches ou artefacts de suivi uniquement comme contexte.

Un fichier de scénarios formel, un template ou un script auxiliaire est
facultatif. S'il a été recherché et manque, signale-le. Son absence ne bloque
pas l'implémentation lorsque le résultat attendu et les preuves nécessaires
sont déjà suffisamment définis. S'il devient indispensable pour décider du
comportement ou vérifier le résultat, arrête-toi et demande comment poursuivre.

Si un fichier est indispensable et absent :

1. indique son nom logique et les chemins testés ;
2. explique ce qu'il empêche de vérifier ou de décider ;
3. demande s'il faut le fournir, le créer ou poursuivre sans lui ;
4. attends la réponse.

Pour chaque source recherchée, indique si elle a été trouvée et lue, si elle
est absente, ou si elle est illisible. Une source optionnelle absente ne bloque
pas ; une source explicitement requise par le projet ou nécessaire pour
comprendre, décider ou vérifier bloque jusqu'à clarification. Si le projet
désigne un fichier `clean-code` ou équivalent comme obligatoire et qu'il manque,
arrête l'étape concernée. Lorsqu'un tel fichier est désigné comme obligatoire,
lis-le avant toute écriture et traite chacune de ses règles applicables comme
un critère de fin obligatoire, pas comme un conseil.

Si une information durable, utile et confirmée doit être conservée dans
`notes.<module>.md` :

- mets le fichier à jour lorsqu'il existe et que l'information est clairement
  rattachée au module ;
- crée-le si le dossier du module et le nommage sont identifiables sans ambiguïté ;
- si son emplacement reste ambigu, signale que l'information ne sera pas
  persistée et demande une précision uniquement si cette persistance est
  nécessaire ;
- ne transforme jamais une interprétation en règle écrite.

## 3. Diagnostic avant écriture

Inspecte le comportement et l'implémentation existants avant toute modification.
Identifie les fichiers, symboles, interfaces, ressources, dépendances et
contrôles réellement concernés.

Présente ensuite :

- le comportement actuel ;
- la cause ou le manque observé ;
- la modification proposée ;
- les fichiers concernés ;
- les risques et limites ;
- les contrôles prévus.

Demande l'accord avant de commencer la tranche lorsque le périmètre, le
comportement ou le choix de conception nécessite une décision.

Si la tâche est explicitement définie et qu'aucune décision supplémentaire
n'est nécessaire, l'autorisation initiale de l'utilisateur, y compris une
consigne de continuation faisant suite à cette définition, suffit : ne demande
pas une confirmation supplémentaire par simple formalisme.

## 4. Implémentation par tranches

Pour chaque tranche approuvée :

1. décris le résultat observable attendu ;
2. modifie uniquement le périmètre validé ;
3. réutilise les composants et conventions existants lorsqu'ils conviennent ;
4. n'effectue aucun refactor opportuniste ;
5. exécute les contrôles proportionnés aux fichiers et comportements touchés.

Pour chaque tranche, choisis une preuve de vérification proportionnée à la
nature, au risque et à l'impact du changement :

1. distingue les cas déduits des sources fiables des cas qui nécessitent une
   décision métier ;
2. arrête-toi sur toute règle métier ambiguë au lieu de l'inventer ;
3. pour un comportement observable, couvre les cas positifs, négatifs et
   limites applicables ;
4. pour une documentation, une configuration ou une correction à faible
   impact, privilégie les contrôles structurels et ciblés réellement utiles ;
5. choisis le niveau adapté : unitaire, composant, intégration, E2E ou scénario
   manuel ;
6. écris ou adapte un test automatisé lorsque le comportement est
   automatisable et que ce test apporte une preuve utile ;
7. si aucun test automatisé pertinent n'est possible, produis un scénario
   manuel structuré ou un contrôle observable dans le compte rendu ;
8. exécute les preuves et contrôles applicables avant de déclarer la tranche
   terminée.

Les tests doivent correspondre au comportement et aux risques du périmètre.
N'ajoute ni ne présente de tests artificiels, hors sujet ou sans preuve utile.
Pour un comportement backend soumis à une convention TDD du projet, écris et
exécute d'abord les tests pertinents pour constater l'échec attendu, puis
implémente. Couvre les cas positifs (données valides), négatifs (données
invalides et rejets), limites (seuils et frontières) et edge cases (données
inhabituelles mais valides) lorsqu'ils s'appliquent ; justifie brièvement toute
catégorie non applicable et n'invente jamais les attentes métier.

Cette vérification ne force pas un test unitaire artificiel pour une navigation,
un parcours complet ou une interaction entre services. Elle ne modifie pas
automatiquement le fichier des tâches et ne crée pas de fichier de scénarios
sans emplacement explicitement autorisé.

Ne modifie jamais un résultat attendu uniquement pour faire passer un test.
Lorsque les attentes sont insuffisantes pour écrire un test fiable, signale-le
et demande la précision nécessaire.

Pour une interface, vérifie seulement les états applicables : initial,
chargement, vide, validation, succès, erreur, permission, récupération et
accessibilité.

Pour un service ou un traitement, vérifie seulement les entrées, sorties,
erreurs, autorisations, dépendances et cas limites concernés.

## 5. Écart de données ou de schéma

Si la tâche nécessite une table, colonne, relation, contrainte, index, type,
nullabilité, migration ou donnée de référence absente de la conception validée :

- arrête l'implémentation concernée ;
- explique l'écart, son impact et les fichiers concernés ;
- prépare une transmission à `$db-sync <module>` avec le module, l'écart,
  les sources comparées et les artefacts potentiellement concernés ;
- ne modifie ni le schéma, ni la migration, ni le seed, ni la base pour contourner
  l'écart ;
- n'invoque pas automatiquement `$db-sync` : l'utilisateur doit lancer cette
  commande ou demander explicitement la transmission ;
- attends la décision et le résultat de la synchronisation avant de reprendre.

Après `$db-sync`, relis les artefacts réellement modifiés et vérifie qu'ils
résolvent l'écart avant de reprendre l'implémentation. Ne considère jamais la
synchronisation comme une implémentation applicative terminée.

Si `$db-sync` est nécessaire mais indisponible ou illisible, indique le handoff
non réalisable, les artefacts concernés et le blocage exact. N'invente pas une
synchronisation locale et ne modifie pas le schéma pour contourner l'absence de
la commande.

## 6. Vérification et fin

Exécute les contrôles réellement applicables à la tranche : formatage, analyse
statique, compilation, tests ciblés, vérification d'interface ou contrôle
d'intégration non destructif, selon les outils déclarés par le projet.

Avant le verdict, vérifie le comportement réellement livré, et pas seulement le
code source. Si le changement nécessite qu'une application, un serveur ou un
backend soit redémarré pour prendre effet, utilise la procédure documentée du
projet pour le redémarrer, puis contrôle son démarrage et le fonctionnement du
parcours touché (par exemple un endpoint de santé et le comportement modifié).
Ne redémarre pas un service sans nécessité. Si un redémarrage ou un contrôle
fonctionnel nécessaire ne peut pas être réalisé, indique le blocage et marque
la tranche `NON TERMINÉE` ; ne certifie pas le fonctionnement sur la seule base
de la compilation ou de tests qui ne couvrent pas ce point.

Après une correction significative, relance les contrôles concernés.

Une tranche est `DONE` uniquement si les contrôles applicables sont réussis.
Sinon, indique `NON TERMINÉE`, la cause exacte et le contrôle restant.

Une tranche n'est `DONE` que si sa preuve réexécutable est présente et exécutée
avec succès. Si un contrôle requis ne peut pas être exécuté, indique
`NON TERMINÉE` et précise le blocage au lieu de certifier le résultat.

Ne déclare pas toute une fonctionnalité terminée tant que les autres tâches ne
sont pas explicitement traitées.

Le compte rendu indique :

- contexte et périmètre retenus ;
- fichiers modifiés ;
- comportement obtenu ;
- contrôles exécutés et résultats ;
- preuve proportionnée retenue, cas couverts, contrôles exécutés et cas restant
  à retester ;
- règles ajoutées aux notes, le cas échéant ;
- critères d'acceptation ou tests couverts et non vérifiés, lorsqu'ils existent ;
- écarts BDD détectés ;
- limites et décision attendue ;
- prochaine action, sans lancer une autre commande automatiquement.
