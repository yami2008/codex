---
name: create-prd
description: Interviewer l'utilisateur question par question pour produire le prd.md d'un projet (carte d'identité, niveau vision). À lancer une seule fois par projet, au démarrage ; ne pas activer pour modifier un prd.md existant sauf demande explicite.
---

# Create PRD

Invocation Codex : `$create-prd`

Produire le PRD qui sert de carte d'identité au projet.
Le document reste au niveau vision.
Il ne remplace pas la spécification détaillée d'un module.

Cette commande est indépendante du projet, de la stack, des technologies et des
langages. Elle s'adapte aux conventions documentaires réellement déclarées.

## Préparation et résolution de la sortie

Avant toute recherche, lis les règles applicables du dépôt lorsqu'elles existent
(`AGENTS.md`, `CLAUDE.md` et conventions explicitement désignées).
Ne traite pas ces fichiers comme des sources métier.

Si une règle ou un chemin est explicitement désigné mais absent ou illisible,
arrête-toi, indique le chemin testé et demande une décision. Si aucune règle
locale n'est trouvée, signale cette absence et poursuis avec les seules
informations confirmées par l'utilisateur.

Localise avec `rg --files` les éventuels `prd.md` et fichiers équivalents.
Ne présume aucun dossier de documentation.

- Si un PRD existe déjà, signale son chemin et arrête la commande.
  Demande s'il faut utiliser un autre chemin ou modifier explicitement ce PRD.
- Si plusieurs PRD sont trouvés, liste-les et demande lequel fait foi.
- Si aucune convention de sortie n'est déclarée, propose un chemin après
  l'interview et attends sa validation.
- N'écrase jamais un fichier existant sans demande explicite.

Le fichier de référence [references/prd-structure.md](references/prd-structure.md)
est obligatoire pour la génération. S'il est absent, signale-le et arrête-toi.

Pour chaque source recherchée, distingue toujours : trouvée et lue, absente,
ou illisible. Une source optionnelle absente ne bloque pas ; une source
nécessaire à une décision ou à la génération bloque jusqu'à clarification.

## Déroulé de l'interview

Poser les questions UNE PAR UNE, dans cet ordre. Attendre la réponse avant de passer à la suivante.
À chaque réponse : reformuler brièvement, challenger si quelque chose semble incohérent ou flou, débattre si l'utilisateur le souhaite. Ne passer à la question suivante qu'une fois le point acté.
À tout moment : toute zone d'ombre ou décision impossible à prendre seul remonte à l'utilisateur.
Poser librement toutes les questions nécessaires, ne jamais trancher à sa place.

1. Intitulé du projet (nom + sigle éventuel).
2. Intérêt du projet : quel problème il résout, pour qui, pourquoi maintenant.
3. Utilisateurs principaux (profils/acteurs, pas de personas détaillés).
4. Modules prévus : liste + priorité. Un module = un nom + une phrase d'objectif, pas plus.
5. Plateformes cibles (Web, Mobile, Bureau).
6. Technologies, langages, frameworks ou solutions retenues, si elles sont déjà connues.
7. Base de données.
8. Architecture : monolithe ou microservices, et les principes non négociables qui en découlent.
9. Outillage et exploitation : moyens prévus pour développer, vérifier, livrer,
   héberger et gérer le code, uniquement lorsque ces sujets s'appliquent.
10. Contraintes majeures : réseau, taille d'équipe, sécurité, données sensibles, ordre de développement.

Si une question ne s'applique pas au projet, signale-le et demande si elle doit
être retirée ou conservée comme « à préciser ».

Ensuite, demander : « Y a-t-il d'autres informations à ajouter ? » et traiter
chaque ajout de la même façon (discussion → accord).

Quand tout est acté, annonce que le PRD peut être généré.
Demande la langue de rédaction si elle n'est pas déjà claire.
Demande ensuite où écrire le fichier, puis attends la réponse avant toute écriture.
Si le chemin cible existe, arrête-toi et demande une décision explicite.

Avant l'écriture, récapitule les réponses actées, les éléments laissés « à
préciser », les sources lues et les sources absentes ou illisibles. Ne génère
aucune section à partir d'une hypothèse.

Si l'interview confirme une information durable, utile et rattachable sans
ambiguïté à un module, la commande peut mettre à jour `notes.<module>.md` selon
les conventions du projet. Elle ne crée pas une note pour recopier le PRD ou
le résultat de l'interview. Si l'emplacement est ambigu, signale que la note
ne sera pas persistée et poursuis sans l'inventer.

## Règles de rédaction du prd.md

- Rédiger dans la langue explicitement choisie par l'utilisateur ou imposée par
  les conventions du projet. Si aucune langue n'est déterminable, demander.
- Phrases COURTES. Casser toute phrase longue en plusieurs lignes avec `\` en fin de ligne (retour ligne dur Markdown).
- Tableaux pour les listes énumérables (objectifs, utilisateurs, choix techniques), prose brève ailleurs.
- Chaque module non prioritaire : une ligne « Plus de détails plus tard. » suffit.
- En-tête : titre, version, date, statut.
- Ne rien inventer : tout le contenu vient des réponses actées pendant l'interview.

Structure de référence (adaptable si le projet le justifie) : lire [references/prd-structure.md](references/prd-structure.md) au moment de générer le fichier.

## Garde-fous

- Si un `prd.md` existe déjà à l'emplacement cible, le signaler et demander avant d'écraser.
- Ne pas dériver vers la spécification détaillée d'un module : recadrer poliment vers le niveau vision.
