# Modèle du fichier de plan

Le plan final est un fichier Markdown adapté à la fonctionnalité demandée. Garder les trois sections dans cet ordre. Omettre une section si elle ne contient aucune entrée.

```markdown
# Plan — <Nom de la fonctionnalité>

## Tâches retenues

- [ ] 01. <Tâche retenue du catalogue>
- [ ] 02. <Tâche retenue du catalogue>

## À décider

- [ ] 03. <Question concrète permettant de décider si la tâche s'applique>

## Tâches supplémentaires proposées (à valider)

- [ ] 04. <Tâche nouvelle proposée>
  - Pourquoi : <bénéfice et raison pour laquelle le catalogue ne la couvre pas>
```

Règles de format :

- Le titre suit `# Plan — <Nom de la fonctionnalité>`.
- Chaque item est une case non cochée avec un numéro à deux chiffres : `[ ] 01. ...`.
- Les numéros sont uniques et séquentiels dans le fichier, en parcourant les sections dans leur ordre d'affichage.
- Les éléments de « À décider » sont formulés comme des questions qui aident l'utilisateur à les retenir ou à les écarter.
- Les tâches supplémentaires restent des propositions non approuvées ; leur justification est une sous-puce, sans numéro additionnel.
- Ne pas ajouter de sections génériques ou de prescriptions techniques qui ne découlent ni de la demande ni des catalogues.
