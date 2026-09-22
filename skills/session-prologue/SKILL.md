---
name: session-prologue
description: Lance les composants internes d’un projet à partir d’un runbook ou d’un contrat de démarrage documenté, sans diagnostiquer ni tester une stack non déclarée.
---

# Session Prologue

Invocations valides :

- `$session-prologue`
- `$session-prologue <chemin-du-runbook>`
- `$session-prologue <chemin-du-runbook> -force`

Sans chemin, la sélection suit les règles ci-dessous. `-force` est facultatif et
ne peut apparaître qu'une seule fois. Un seul chemin est accepté ; tout autre
argument, plusieurs chemins ou plusieurs occurrences de `-force` bloquent
l'exécution et doivent être signalés.

Un chemin fourni par l'utilisateur est résolu depuis l'espace de travail actif,
pas depuis le répertoire de cette skill.

## Rôle

C'est le seul rôle de cette commande : lancer les composants internes
décrits par un runbook ou un contrat de démarrage.

Si le runbook ou la demande confirme une information durable, utile et
rattachable sans ambiguïté à un module, la commande peut mettre à jour
`notes.<module>.md` selon les conventions du projet. Elle ne crée jamais une
note pour recopier la cartographie de démarrage. Si le module ou la cible de
note est ambigu, elle signale que l'information ne sera pas persistée.

Aucun chemin, format, nom de composant ou outil de démarrage n'est imposé par
cette skill. Ces informations viennent du document retenu ou de la demande.

Elle ne réalise pas un audit général de l'environnement et ne doit pas
ralentir le démarrage par des contrôles de santé systématiques.

Le document retenu est la seule source de vérité pour :

- les composants à lancer ;
- leur rôle, leur répertoire et leur mode d'exécution ;
- les commandes exactes de démarrage ;
- les profils et variables d'environnement ;
- les dépendances et l'ordre de démarrage ;
- le caractère requis ou optionnel de chaque composant ;
- les contrôles de santé utilisables uniquement lorsque `-force` est demandé.

N'invente jamais une commande, un profil, un répertoire, une dépendance ou un
contrôle à partir de la stack détectée.

## Sélection du runbook

1. Si un chemin est fourni, résous-le dans l'espace de travail, vérifie qu'il
   existe et utilise exactement ce fichier, quel que soit son format déclaré.
   S'il est absent ou illisible, arrête-toi, indique le chemin testé et demande
   un autre document ; ne bascule pas silencieusement vers une autre source.
2. Sans chemin fourni, recherche d'abord les contrats ou runbooks dans les
   emplacements et sous les noms désignés par les instructions du projet.
3. Si aucun emplacement n'est désigné, recherche les fichiers de contrat ou de
   runbook par leur nom réel dans le dépôt actif, notamment les noms
   `SESSION_CONTRACT.md`, `SESSION_CONTRAT.md`, `CONTRAT_SESSION.md`,
   `RUNBOOK.md` ou les fichiers dont le nom contient `runbook`, `contrat` ou
   `contract`, sans privilégier une stack, un framework ou une organisation de
   dossiers.
4. Si plusieurs documents sont candidats, liste-les et demande lequel fait foi.
5. Si aucun document n'est trouvé, arrête-toi et demande un chemin de runbook
   ou un contrat de démarrage.

Ne sélectionne jamais automatiquement un fichier voisin pour compléter un
runbook explicite.
Ne déduis jamais un profil à partir d'une stack ou d'une convention de framework.

Le document retenu doit fournir au minimum, pour chaque composant à lancer, son nom,
son répertoire et sa commande. Les dépendances, profils, variables et états
requis ou optionnels doivent être suffisamment explicites pour déterminer le
lancement. Un contrôle de santé n'est requis que si le mode `-force` doit
pouvoir certifier le fonctionnement du composant.

Si le document retenu désigne une annexe, une convention, un profil ou une
source complémentaire indispensable, résous exactement cette source. Si elle
est absente ou illisible, arrête-toi, indique le chemin testé et demande une
seule décision ; ne la remplace pas par un fichier voisin.

Les composants requis sont lancés selon le document. Un composant optionnel est
lancé uniquement si le document le demande par défaut ou si l'utilisateur le
demande explicitement. Si son statut, sa commande ou sa dépendance est ambigu,
arrête-toi et demande une précision.

Si une information requise manque, est illisible ou se contredit :

1. indique précisément le manque ou la contradiction ;
2. explique ce qu'il empêche de lancer ;
3. pose une seule question avec les options possibles et une recommandation ;
4. attends la réponse.

## Règles de sécurité et de périmètre

- Utilise uniquement l'espace de travail et les composants internes documentés.
- N'exécute aucune commande de démarrage absente du document retenu.
- Lance les processus persistants en arrière-plan, sans fenêtre shell visible et
  sans interaction utilisateur.
- Ne montre, n'enregistre et ne transmets jamais la valeur d'un secret.
- Masque les valeurs sensibles dans la cartographie, les logs et le bilan.
- Les composants externes, notamment les bases de données et fournisseurs
  d'identité, ne sont jamais démarrés par cette commande sauf s'ils sont
  explicitement déclarés comme composants internes dans le runbook.
- Les migrations et seeds sont interdits par défaut.
- Une migration ou un seed n'est autorisé que si la demande utilisateur le
  précise explicitement et si l'artefact est documenté par le runbook.
- Les tests métier ne font pas partie de cette commande par défaut.

## Mode normal

Sans `-force`, après la sélection et la lecture du runbook :

- n'effectue pas d'inventaire des processus, des conteneurs ou des ports ;
- ne vérifie pas si un composant est déjà sain, actif ou fonctionnel ;
- ne lance pas de contrôle de santé et n'attend pas la disponibilité applicative ;
- exécute une fois la commande documentée de chaque composant interne requis ou
  optionnel demandé, dans l'ordre de ses dépendances ;
- peut lancer en parallèle uniquement les composants déclarés indépendants ;
- ne redémarre, ne reconstruit et ne recrée aucun composant ;
- ne lance pas les composants aval dont une dépendance documentée n'a pas pu
  être démarrée ;
- rapporte le résultat de la création des processus, sans prétendre certifier
  leur santé finale.

Un composant déjà actif n'est pas recherché ni réutilisé en mode normal : la
commande documentée est simplement exécutée une fois. La gestion d'un état
existant relève de `-force`.

## Mode `-force`

Avec `-force`, la commande peut inspecter l'état des composants documentés et
prendre les mesures ciblées nécessaires pour obtenir un démarrage fonctionnel,
dans les limites des droits disponibles :

- réutiliser un composant déjà sain ;
- relancer ou redémarrer un composant absent, arrêté ou défaillant ;
- appliquer uniquement la commande et le profil documentés ;
- utiliser les contrôles de santé documentés pour confirmer le résultat ;
- effectuer des tentatives de réparation bornées et s'arrêter si le problème
  persiste ;
- signaler clairement tout composant externe ou toute action impossible avec les
  droits disponibles.

`-force` ne reconstruit ni ne recrée un composant sauf autorisation explicite du
runbook. Il ne réalise jamais de `drop`, `reset`, suppression ou autre action
irréversible sur les données sans demande explicite.

Même avec `-force`, une ambiguïté indispensable, une commande manquante ou une
action présentant plusieurs choix techniques impose un arrêt et une question.

## Exécution

1. Sélectionne et lis le contrat retenu.
2. Résous le répertoire, la commande, le profil et les variables de chaque
   composant sans afficher les valeurs sensibles.
3. Lance chaque commande exactement telle qu'elle est documentée, depuis le
   répertoire et avec l'environnement documentés. Ne la reformule pas et ne la
   remplace pas par une commande équivalente.
4. Pour un processus persistant, utilise le mécanisme natif de l'environnement
   pour le détacher, le rendre non interactif et masquer sa fenêtre. Sous
   Windows, une fenêtre shell ne doit pas être visible. Ne transforme pas une
   commande de premier plan en service ou en conteneur sans que le runbook le
   demande.
5. En mode normal, arrête le travail après la remise des commandes aux
   processus.
6. En mode `-force`, effectue uniquement les diagnostics, réparations et
   contrôles nécessaires à la remise en état documentée.

Si une commande déclarée est introuvable ou si son lancement échoue, rapporte
l'erreur exacte, n'invente pas de remplacement et ne lance pas les composants
qui en dépendent.

Ne remplace jamais un contrôle de santé documenté par une URL, un port ou une
commande supposée. N'exécute aucune action métier pour tester la disponibilité.

## Nettoyage des traces temporaires

- Ne supprime que les traces créées par l'invocation courante.
- Place une trace temporaire indispensable dans un dossier temporaire dédié.
- Ne supprime jamais une trace préexistante ou d'appartenance incertaine.
- Vérifie la disparition du dossier temporaire avant le bilan.
- Ne relance pas un composant sain uniquement pour nettoyer une trace.

## Bilan obligatoire

Le bilan commence toujours par, y compris lorsqu'une erreur de sélection ou une
information manquante impose un arrêt :

```text
SESSION PROLOGUE CONTEXT
```

Puis il indique brièvement :

- l'espace de travail utilisé ;
- le chemin du runbook retenu ;
- les sources lues ;
- le profil utilisé ;
- les composants ciblés ;
- les commandes remises aux processus et leur résultat de lancement ;
- le mode utilisé (`normal` ou `-force`) ;
- les migrations ou seeds exécutés, s'il y en a ;
- les corrections tentées ;
- les blocages et informations manquantes.

Les sources désignées mais absentes ou illisibles sont également listées dans
le bilan. Une source non nécessaire ne doit pas provoquer un audit général de
l'environnement.

En mode normal, ne déclare jamais la session prête sur la seule base du
lancement des processus. Si toutes les commandes requises ont été remises aux
processus, ajoute :

```text
SESSION PROLOGUE LAUNCHED
```

En mode `-force`, ajoute `SESSION PROLOGUE READY` uniquement si tous les
composants requis ont été confirmés par leurs contrôles documentés. Sinon
ajoute clairement :

```text
SESSION NON PRÊTE
```

Ne déclare jamais la session prête si un composant requis n'a pas été vérifié
ou si une information indispensable reste inconnue.
