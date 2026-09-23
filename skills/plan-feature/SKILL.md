---
name: plan-feature
description: Build a numbered, project-independent feature plan from the user's task catalogs; use when the user asks to plan a feature before implementation.
---

# Planifier une fonctionnalité

Cette compétence transforme une demande fonctionnelle en un fichier Markdown de plan, à partir des catalogues de tâches personnels de l'utilisateur. Elle ne dépend d'aucun projet, langage, framework, technologie ou architecture et ne met pas en œuvre la fonctionnalité.

Invocation attendue : `$plan-feature <fonctionnalité> [contexte métier facultatif]`.

## Sources de référence

Les fichiers de tâches sont la source de vérité. Dans l'installation actuelle, ils se trouvent à côté du dossier `skills` :

- `Tasks_Liste.txt`
- `Tasks_Add.txt`
- `Tasks_Update.txt`
- `Tasks_Delete.txt`

Résoudre leur emplacement relativement à cette compétence : remonter de `skills/plan-feature` au dossier `.agents`. Ne pas chercher ni utiliser silencieusement des copies portant le même nom dans le projet.

Si un catalogue est absent, illisible ou contradictoire avec une source utilisateur, ne génère pas de plan partiel. Informe l'utilisateur du fichier et du problème précis, puis pose une seule question ciblée et attends sa réponse. Ne crée pas, ne répare pas et ne modifie pas les catalogues sans demande ou acceptation explicite.

Pour un type de fonctionnalité qui n'a pas de catalogue correspondant (par exemple « consulter » ou « joindre des fichiers »), ne prétends pas qu'un modèle existe. Si des tâches communes applicables figurent dans un catalogue existant, elles peuvent être retenues. Pour le reste, arrête la génération et demande si l'utilisateur souhaite fournir/créer un catalogue ou autoriser un premier plan exploratoire. Ne présente pas des propositions supplémentaires comme des tâches déjà approuvées.

## Déroulement

1. **Cadrer la fonctionnalité.** Identifie l'action, l'objet concerné et le contexte métier fourni. N'infère pas une règle métier ni un choix d'interface absent. Si l'action ou l'objet reste ambigu et que cette ambiguïté change le choix des tâches, arrête-toi et pose une question ciblée.
2. **Lire les catalogues pertinents.** Lis les fichiers de référence réellement concernés. Les catégories actuelles sont Liste, Ajout, Modification et Suppression. Ne suppose pas qu'elles couvrent d'autres actions.
3. **Sélectionner les tâches.** Répartis les entrées existantes en tâches clairement applicables, décisions facultatives à prendre et tâches clairement non pertinentes (à omettre). N'inclus pas chaque tâche par défaut. Respecte la demande et les règles explicites de l'utilisateur. Les choix dont la réponse est essentielle pour produire un plan juste bloquent la génération ; les options facultatives peuvent figurer dans « À décider ».
4. **Repérer les propositions nouvelles.** Tu peux proposer zéro, une ou deux tâches supplémentaires au maximum, uniquement si elles apportent une couverture utile absente des catalogues. Indique brièvement pourquoi chaque proposition manque au catalogue. Elles restent non approuvées tant que l'utilisateur ne les accepte pas explicitement.
5. **Résoudre les ambiguïtés.** Aucune décision ne doit être prise au hasard. Si une information nécessaire manque, une contradiction existe, ou plusieurs interprétations changent le plan, arrête-toi, expose le blocage précisément, pose une seule question à la fois et attends la réponse. N'écris pas de fichier de plan incomplet pendant cette attente. Les décisions facultatives prévues pour la section « À décider » ne bloquent pas : formule-les clairement et laisse l'utilisateur trancher.
6. **Utiliser `$impl-brainstorm` au besoin.** L'utilisateur autorise cette compétence à faire appel à `$impl-brainstorm` lorsqu'une discussion de cadrage peut lever une ambiguïté ou aider à décider quelles tâches retenir. Fais-le seulement si le périmètre et les éléments requis par cette compétence sont identifiables ; sinon pose d'abord la question manquante. Le brainstorm peut clarifier le besoin, mais ne vaut pas approbation des tâches ni autorisation de modifier les catalogues. Après le brainstorm, reprends la sélection avec les décisions explicitement validées. Ne lance aucune implémentation.
7. **Créer le fichier.** Génère le plan avec le modèle lié ci-dessous. Tous les items du plan reçoivent un numéro séquentiel à deux chiffres, unique dans ce fichier, au format exact `[ ] 01. Texte de la tâche.`. Numérote dans l'ordre de lecture, à travers les sections. Lors d'une mise à jour du même plan, conserve les numéros existants ; donne aux nouvelles tâches les prochains numéros libres. N'attribue pas d'identifiant qui prétend être stable entre des plans distincts.
8. **Choisir l'emplacement sans supposer de structure technique.** Si le contexte identifie sans ambiguïté un dossier de module existant qui convient à la fonctionnalité, enregistre le plan dans ce dossier. Sinon, utilise le dossier de planification/documentation déjà établi dans le dossier courant s'il est évident ; à défaut, crée/emploie `plans/` sous le dossier courant. Le nom du fichier est `plan-<slug-de-la-fonctionnalité>.md`. Si plusieurs dossiers de module/planning conviennent, si le dossier courant n'est pas identifiable, ou si un fichier homonyme existe et qu'il n'est pas clair s'il faut le remplacer ou le mettre à jour, arrête-toi et demande où/comment procéder. Ne remplace jamais un fichier existant sans accord.
9. **Présenter le résultat.** Indique le chemin du fichier créé et résume les points à décider ainsi que les propositions supplémentaires. N'affirme pas qu'une proposition est acceptée.

## Contenu et limites

- Le fichier contient trois sections : `Tâches retenues`, `À décider` et `Tâches supplémentaires proposées (à valider)`. Une section facultative vide peut être omise.
- Pour les tâches retenues, conserve le sens du catalogue et reformule seulement pour la clarté, sans ajouter de décision. Pour « À décider », transforme les options en questions concrètes et neutres.
- Les plans décrivent des tâches et comportements attendus, pas une solution de code. Les termes déjà présents dans le catalogue (API, cache, Fetch once, etc.) peuvent être repris, mais n'impose aucune stack ni architecture.
- Interprète les stratégies de récupération selon les définitions confirmées par l'utilisateur : **Fetch Once** consiste à réutiliser côté frontend des données déjà récupérées au lieu de refaire inutilement les mêmes appels ; **Fetch Fusion** consiste à fournir en un appel regroupé plusieurs ensembles de métadonnées nécessaires ensemble (par exemple devises, prestations et pays) afin d'éviter plusieurs appels API séparés. Ce sont des options à évaluer selon le besoin ; ne les rends pas obligatoires par défaut.
- Ne fais pas d'exploration de code ou de schéma pour inventer le plan. Le contexte du projet sert uniquement à reconnaître un dossier de module ou de planification pour enregistrer le fichier.
- Après acceptation explicite d'une ou plusieurs tâches supplémentaires, ajoute uniquement les tâches acceptées au catalogue approprié, en préservant son format et le texte existant. Si le bon fichier/catégorie ou l'emplacement d'insertion est ambigu, demande avant de modifier. Ne transforme jamais une proposition en décision implicitement.
- Les réponses de l'utilisateur aux éléments « À décider » peuvent être appliquées au plan. Ne modifie le catalogue que si l'utilisateur accepte explicitement l'ajout ou la modification d'une règle de référence.
- Ne modifie aucun autre fichier de projet, aucune configuration et aucun code.

Utilise le format exact défini dans [references/plan-template.md](references/plan-template.md).
