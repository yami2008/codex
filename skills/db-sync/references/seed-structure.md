# Gabarit d'un artefact de données de référence ou d'essai

Structure de référence du script de **données** d'un module : valeurs de référence et jeu d'essai.

Les noms `seed.<module>.sql` et les exemples SQL ci-dessous sont illustratifs.
Ils ne sont applicables que si le projet déclare ce format et ce langage.
Pour un autre SGBD ou format, conserve les invariants et adapte la syntaxe selon
les conventions documentées du projet.

Ce gabarit est **portable** : la syntaxe se traduit dans le SGBD du projet, le plan et les règles ne changent pas.

**Qui l'écrit :** la commande explicitement autorisée à produire le changement,\
notamment `$db-sync` lorsqu'il est lié à un écart BDD approuvé.\
Une autre commande ne le modifie pas sans autorisation explicite.

---

## Deux contenus, un seul fichier

| Contenu | Exemple | Vit en production ? |
|---|---|---|
| **Valeurs de référence** | statuts, types, taux fixes, catalogue de codes | Oui |
| **Jeu d'essai** | données réalistes pour tester un flux de bout en bout | Non |

Les deux peuvent cohabiter, mais **jamais mélangés** : sections séparées, en-tête qui le dit.\
Un jeu d'essai chargé en production est un incident ; il doit être identifiable d'un coup d'œil.

---

## La règle non négociable — idempotence

Le script doit pouvoir être **rejoué sans créer de doublon** et sans lever d'erreur.

Deux stratégies, à choisir selon le contenu :

- **Valeurs de référence** → insertion gardée : n'insérer que si la valeur métier est absente.\
  Ne supprime jamais : une valeur de référence peut déjà être utilisée par des données réelles.
- **Jeu d'essai** → purge puis rechargement du **périmètre exact** uniquement
  dans un environnement explicitement autorisé, avec des identifiants
  **déterministes** (jamais générés aléatoirement). C'est ce qui rend la purge
  ciblée possible.

Un jeu d'essai à identifiants aléatoires n'est pas rejouable : à la deuxième exécution, il double tout.

---

## Le plan, dans l'ordre

    Module et version : <nom, service éventuel, version>
    Cible : <environnement et stockage explicitement autorisés>
    Périmètre : <données chargées, et rien d'autre>
    Origine : <source métier, source existante ou valeur explicitement validée>
    Prérequis : <données ou composants attendus avant exécution>
    Idempotence : <stratégie retenue>
    Cas couverts : <cas limites réellement représentés>

    Étape N — <titre>
    Références : <résolution via clé métier stable ou référence documentée>
    Action : <instruction dans le format du projet>
    Vérification : <preuve du résultat attendu>

    Récapitulatif : <compte réellement vérifié des données créées ou mises à jour>

Pour un projet SQL, ces éléments peuvent être exprimés dans un script SQL. Pour
un autre stockage ou format, conserve le même plan avec les conventions du
projet.

---

## Jamais d'identifiant externe en dur

Une référence provenant d'une autre source — a fortiori d'un autre service — se
**résout à l'exécution** par une clé métier stable ou une référence explicitement
documentée, jamais recopiée en dur dans l'artefact.

Un identifiant recopié est vrai sur un poste et faux sur tous les autres.

Si la résolution ne trouve rien, la valeur est nulle et l'insertion sera incohérente :\
dis-le en commentaire d'en-tête, avec le **prérequis** qui l'évite.

---

## La liste « CAS COUVERTS » — ce qui fait la valeur du fichier

Un jeu d'essai qui ne contient que le cas nominal ne sert à rien : le cas nominal marche toujours.

L'en-tête liste explicitement les **cas limites** que les données couvrent —\
enregistrement incomplet, exonération, cas aux bornes d'une période, chaînage partiel.

C'est cette liste qu'on relit avant de tester, pas les données elles-mêmes.

---

## Détails qui comptent

- Le **compte réel** en fin de fichier (« 93 lignes, 58 rattachements ») : il vérifie une exécution d'un coup d'œil.
- Le **prérequis** est explicite : quels autres seeds doivent être passés avant, et pourquoi.
- Un seed écrit à la main par l'utilisateur, hors de ces deux commandes, **ne se touche pas** sans demande explicite.
- Commentaires courts, avec la syntaxe du format déclaré par le projet ; une
  idée par ligne.
