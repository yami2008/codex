# Contrat : règles de saisie et cas à vérifier

**À confirmer par le responsable du module Contrat.** Ces règles viennent de plans de vérification
écrits avant le développement et jamais exécutés. Elles peuvent ne pas correspondre au code actuel :
les vérifier avant de s'en servir, puis corriger ce document.

## Cycle de vie

- Un contrat est créé au statut BROUILLON. Un brouillon incomplet peut être enregistré depuis n'importe quelle étape.
- La validation finale laisse le contrat en BROUILLON : il n'est pas soumis automatiquement au juridique.
- Une modification enregistrée garde le même contrat et son statut ; elle ne fait pas avancer le workflow.
- « Supprimer » un contrat est en réalité un **abandon** : le contrat passe à l'état ABANDONNE, ses données, pièces jointes et traces sont conservées, rien n'est supprimé physiquement.
- L'abandon n'est proposé que pour les contrats qui peuvent être abandonnés : il est masqué pour un contrat déjà abandonné, officiel ou résilié. Le backend vérifie les droits et la transition.
- Un contrat utilisé ailleurs ne peut pas être modifié : la modale « Modification impossible » s'affiche.

## Interactions entre les champs

Ce sont les cas où les bugs se cachent ; chacun mérite une vérification, en création comme en modification.

- **Type de contrat modifié** : les grilles tarifaires dépendantes sont rechargées. Si la grille déjà choisie devient incompatible, une confirmation est demandée et les champs concernés sont signalés.
- **Aéroports modifiés** : les biens disponibles sont rechargés. Les biens devenus incompatibles sont signalés et leur correction est confirmée.
- **Date d'effet ou durée modifiée** : la date d'expiration (et l'alerte d'échéance) est recalculée immédiatement ; la date de lancement de l'appel d'offres est revalidée.
- **Mode de passation modifié** : une confirmation est demandée avant de perdre les informations d'appel d'offres ; la date de lancement d'appel d'offres n'apparaît que pour les modes qui l'exigent.
- **Mode de tarification d'un bien ou d'une prestation modifié** : seuls les champs de tarification applicables s'affichent, et les anciennes valeurs devenues inapplicables ne sont pas envoyées.
- **Durée, taux ou éléments tarifaires modifiés** : les montants dérivés et la caution indicative sont recalculés.
- **Client modifié** : le nouveau snapshot client et ses informations dépendantes sont enregistrés.
- **Modification d'un contrat existant** : la synchronisation des biens, prestations, cautions et aéroports ne supprime aucune ligne non concernée, et ne vide jamais en silence les valeurs d'un bien, d'une prestation ou d'une caution quand un champ parent change.
- **Aucune modification** : le bouton d'enregistrement reste désactivé et aucun appel API n'est fait.
