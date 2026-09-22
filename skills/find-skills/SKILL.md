---
name: find-skills
description: Recherche les skills disponibles dans les répertoires locaux lorsque l'utilisateur cherche une capacité, un outil ou un workflow spécialisé.
---

# Find Skills

Cette commande recense et recommande uniquement les skills déjà disponibles
localement dans l'environnement courant, ainsi que les références, scripts et
templates rattachés à ces skills lorsqu'ils sont nécessaires à la demande.
Elle ne recense pas des scripts ou templates autonomes qui ne sont pas fournis
par une skill locale.

Invocation : `$find-skills [requête]`

La requête est optionnelle : sans requête, la commande liste les skills locales
disponibles ; avec une requête, elle filtre les candidates par capacité et
description. Elle ne devine jamais une requête absente.

## Quand l'utiliser

Utilise cette commande lorsque l'utilisateur :

- cherche une skill pour une tâche donnée ;
- demande si une capacité spécialisée existe déjà ;
- veut découvrir une skill ou un workflow local, ou vérifier quelles ressources
  une skill locale fournit ;
- veut étendre les capacités disponibles sans fournir encore de skill précise.

## Contraintes locales

- Ne consulte jamais Internet, un registre distant, GitHub ou un site externe.
- N'exécute jamais `npx`, un gestionnaire de paquets ou une commande
  d'installation distante.
- Ne déduis pas qu'une skill existe à partir d'un nom ou d'un résultat externe.
- Les seuls résultats valides proviennent de fichiers `SKILL.md` présents dans
  les racines locales accessibles et explicitement disponibles à la session.
- Si aucune racine locale n'est accessible, signale-le et arrête la recherche.

## Recherche

1. Identifie le domaine et le besoin exprimé par l'utilisateur.
2. Localise les fichiers `SKILL.md` dans les racines locales accessibles,
   notamment le dossier local `.agents/skills` lorsqu'il existe.
3. Lis le frontmatter `name` et `description` des candidates.
4. Lis le contenu complet uniquement des candidates pertinentes.
5. Résous les références Markdown, les scripts, les templates et les métadonnées
   mentionnés par une candidate pertinente lorsqu'ils sont nécessaires pour
   comprendre ou utiliser sa capacité.
6. Vérifie que la skill couvre réellement le besoin, que ses ressources
   nécessaires sont disponibles et qu'elle respecte ses propres limites avant
   de la recommander.

Si un `SKILL.md` candidat est absent, illisible ou possède un frontmatter
invalide, écarte uniquement cette candidate, signale précisément le problème
et ne recommande pas une capacité déduite de son nom.

Si une référence, un script ou un template explicitement requis par une
candidate est absent ou illisible, écarte cette candidate pour cette demande,
signale la ressource manquante et ne prétends pas que la capacité est
opérationnelle. Une ressource optionnelle absente est signalée sans invalider la
candidate.

La recherche des skills reste en lecture seule : elle ne modifie aucune skill
et ne crée aucun fichier pour stocker son résultat. Exception : si l'utilisateur
confirme pendant la recherche une information durable, utile et rattachable sans
ambiguïté à un module, la commande peut mettre à jour `notes.<module>.md` selon
les conventions du projet. Elle doit alors signaler cette écriture ; si la
cible est ambiguë, elle ne persiste rien.

## Résultat

Pour chaque candidate pertinente, indique :

- son nom réel ;
- son chemin local ;
- la capacité couverte ;
- les limites ou prérequis qui empêchent une utilisation immédiate.

Si aucune skill locale ne correspond :

1. indique qu'aucune skill locale n'a été trouvée ;
2. propose de traiter la demande directement si cela reste possible ;
3. si l'utilisateur veut ajouter une skill, demande un chemin local explicite
   ou indique que cette commande ne peut pas installer une source distante.

Une recherche infructueuse ne justifie jamais l'invention d'une skill, d'un
chemin, d'une commande d'installation ou d'une référence externe.
