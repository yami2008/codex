# Audit de validation : Lister les contrats

> **Date :** 2026-10-10
> **Périmètre :** page `/commercial/contract` (liste, KPI, recherche, filtres, tri, pagination, export, suppression d'un brouillon depuis la ligne).
> **Environnement :** local. `operation-service` (8083) sur la base réelle `egsa_operation`, frontend (4200), compte `test`.
> **Statut au 2026-10-10 (fin de session) :** 19 anomalies, 12 traitées (11 réglées, 1 clôturée non reproduite), 7 ouvertes, toutes mineures. Détail dans la section « Avancement ».

---

## 1. Fonctionnalités couvertes

1. Chargement initial de la liste, sans filtre (`GET /api/contrats`).
2. Pagination (page, taille).
3. Tri par colonne (Contrat, Client / aéroport, Statut, Période).
4. Recherche par mot-clé (`GET /api/contrats/search`).
5. Filtres avancés : statut, type, client, aéroport, échéance, service gestionnaire.
6. Puces de filtre actives et réinitialisation.
7. Indicateurs (KPI) : total, officiels, résiliés, brouillons, échéance < 6 mois, clients / aéroports (`GET /api/contrats/stats`).
8. Export Excel (`GET /api/contrats/export`).
9. Actualisation de la liste.
10. Accès aux actions depuis une ligne : voir, modifier (si modifiable), supprimer un brouillon.
11. Contrôle d'accès à la lecture.

## 2. Méthode

- **Smoke tests API** : appels `GET` en lecture seule, avec le jeton de la session `test`, sur 8083. Paramètres normaux, limites, invalides et hostiles (tri inconnu, mot-clé avec wildcards, taille négative, page hors plage, enum invalide, UUID invalide, sans jeton).
- **Lecture du code** : contrôleur, service, spécifications JPA, composant de liste et service HTTP du frontend.
- **Tests unitaires existants** : `npm test` sur `src/app/features/commercial/contrat/**`. Le `mvn test` n'a pas été lancé pour ne pas recompiler `operation-service` pendant qu'il tourne.

## 3. Résultats des tests automatiques

| Suite | Résultat |
| --- | --- |
| Résultat initial (avant corrections) : frontend, module contrat (85 tests) | 71 passent, 14 échouent |
| État au 2026-10-10 (fin de session) : frontend, module contrat | 136 passent, 0 échoue, build OK |
| État au 2026-10-10 (fin de session) : backend, module contrat | 103 tests, 3 échouent (`ContratTransitionIntegrationTest`, validation 422 au lieu de 400, déjà présents avant les corrections) |

## 4. Anomalies, de la plus grave à la moins grave

| ID | Gravité | Sujet | Origine du constat |
| --- | --- | --- | --- |
| ANO-01 | Majeur | **Réglée** : la liste sans filtre affichait d'anciennes versions, et les KPI ne concordaient pas avec le tableau | Vérifié en direct, corrigé le 2026-10-10 |
| ANO-02 | Majeur | **Réglée** : la colonne « Contrat » triait sur `numeroBrouillon`, vide pour les contrats officiels | Vérifié en direct, corrigé le 2026-10-10 |
| ANO-03 | Majeur | **Réglée** : 11 tests unitaires de la liste et de la page échouaient, le filet de sécurité ne fonctionnait plus | Vérifié (`npm test`), corrigé le 2026-10-10 |
| ANO-04 | Moyen | **Réglée** : si les stats échouaient, les KPI affichaient 0 sans aucun message | Vérifié en direct, corrigé le 2026-10-10 |
| ANO-05 | Moyen | **Réglée** : chercher « Brouillon » seul ne renvoyait rien, alors que la ligne affiche « Brouillon 10 » | Vérifié en direct, corrigé le 2026-10-10 |
| ANO-06 | Moyen | **Réglée** : l'export chargeait 4 requêtes par contrat, sans limite de volume | Lu dans le code, corrigé le 2026-10-10 |
| ANO-07 | Mineur | **Réglée** : un tri sur un champ inconnu renvoyait une erreur 500 au lieu d'une 400 | Vérifié en direct (API), corrigé le 2026-10-10 |
| ANO-08 | Mineur | Le caractère `%` (ou `_`) dans la recherche n'est pas échappé et renvoie tout | Vérifié en direct |
| ANO-09 | Mineur | Paramètres invalides ignorés en silence (échéance inconnue, page négative, taille 0 ou négative) | Vérifié en direct |
| ANO-10 | Mineur | Les stats chargent en mémoire tous les contrats filtrés pour compter les clients | Lu dans le code |
| ANO-11 | Mineur | Le filtre client ne propose que les 100 premiers clients | Lu dans le code |
| ANO-12 | Mineur | `contrat-list-tab.component.ts` (3910 lignes) n'est utilisé nulle part : code mort qui duplique la liste | Vérifié (recherche de références) |
| ANO-13 | Mineur | Le tri sur « Statut » suit l'ordre alphabétique du code, pas l'ordre du cycle de vie | Vérifié en direct (API) |
| ANO-14 | Moyen | **Réglée** : à chaque frappe dans la recherche, les indicateurs repassaient en squelette et disparaissaient brièvement | Trouvé pendant la correction d'ANO-05, vérifié en direct, corrigé le 2026-10-10 |
| ANO-15 | Moyen | **Réglée** : la recherche cherchait dans des champs non affichés (objet, titre, numéro d'AO), et « Br » ne renvoyait rien | Trouvé par test utilisateur, vérifié en direct, corrigé le 2026-10-10 |
| ANO-16 | Mineur | Une recherche sans résultat affiche « Aucun contrat n'est disponible pour le moment », message trompeur | Vérifié en direct (test d'intégration, E-1) |
| ANO-17 | Majeur | **Réglée** : le tiroir des filtres avancés était vide, aucun des 6 filtres n'était utilisable depuis l'écran | Vérifié en direct (test d'intégration, E-2), corrigé le 2026-10-10 |
| ANO-18 | Moyen | **Clôturée (non reproduite)** : les tris « Client / aéroport » et « Statut » semblaient sans effet | Vrais clics vérifiés le 2026-10-10, clôturée sur accord de l'utilisateur |
| ANO-19 | Moyen | **Réglée** : le tri par « Période de validité » ne suivait pas les dates affichées, pour les avenants | Vérifié en base et en direct, corrigé le 2026-10-10 (tri sur la date de début) |

## 5. Détail des anomalies

### ANO-01 : La liste sans filtre affiche d'anciennes versions, et les KPI ne concordent pas

> **Statut : réglée le 2026-10-10.**
>
> - **Correction 1 :** `ContratService.list` passe désormais par la même requête que la recherche, sans filtre. Seules les versions courantes sont listées.
> - **Correction 2 :** `ContratSpecification` exclut aussi les avenants ABANDONNE de la règle « avenants en cours ». Un avenant abandonné n'est plus en cours.
> - **Tests ajoutés :** `ContratServiceTest.list_shouldOnlyQueryCurrentVersions` et `ContratSpecificationTest.listeGardeLesAvenantsEnCoursMaisPasLesAvenantsAbandonnes`. Les deux échouaient avant la correction.
> - **Vérification en direct, après redémarrage de `operation-service` :** liste, recherche et stats renvoient les mêmes 6 contrats. Il n'y a plus de doublon ni de version non courante. L'affichage de `/commercial/contract` montre 6 lignes et le KPI « Total contrats » à 6.
> - **Tests du module Contrat :** 85 tests, dont 3 échecs dans `ContratTransitionIntegrationTest` (validation 422 au lieu de 400). Ces échecs existaient avant ces corrections et ne touchent pas la liste.

- **Constat :** `GET /api/contrats` appelle `repository.findAll(pageable)` sans le filtre `currentUsed`. `GET /api/contrats/search` applique ce filtre. Le frontend appelle l'un ou l'autre selon qu'un filtre est actif.
- **Mesure :** sans filtre, 10 lignes dont 4 versions non courantes (`isCurrentUsed = false`) : `CO/877` (abandonné), `CO/88/SP` (officiel, 3 fois), `CO/55/88` (officiel, 2 fois). Avec la recherche, 7 lignes. Les KPI annoncent `total = 7`.
- **Scénario :** ouvrir `/commercial/contract` sans rien saisir. Le tableau affiche 10 lignes, dont des doublons, et le KPI « Total contrats » affiche 7.
- **Conséquences si on laisse :**
  - Le tableau montre des doublons, ce qui fait croire à des contrats en double.
  - Un utilisateur peut ouvrir une ancienne version et la prendre pour la version en vigueur.
  - Les chiffres de la page se contredisent (7 contre 10).
  - L'export (qui utilise la recherche, donc 7 lignes) ne correspond pas à ce que l'utilisateur voit.

### ANO-02 : La colonne « Contrat » trie sur un champ vide pour les contrats officiels

> **Statut : réglée le 2026-10-10.**
>
> - **Correction 1 :** la colonne « Contrat » (`contrat-data-table.component.ts`) trie désormais sur `numeroOfficiel`.
> - **Correction 2 :** `ContratService.search` (et donc `list`) ajoute `numeroBrouillon` comme second critère quand le tri porte sur `numeroOfficiel`. Les brouillons se rangent entre eux par leur numéro.
> - **Correction 3 (défaut de la correction 2, trouvé après relecture) :** le second critère restait en ascendant même quand le tri principal était en descendant. En descendant, les brouillons sortaient donc « 5 puis 10 ». Il suit désormais le sens du tri principal. Test ajouté : `ContratServiceTest.search_shouldFollowSortDirectionForDraftNumberTieBreak`.
> - **Choix de tri à confirmer :** en ascendant, les brouillons apparaissent avant les officiels, et en descendant après. C'est le comportement de SQL Server pour les valeurs vides. Si vous préférez les brouillons en fin de liste dans les deux sens, c'est un ajustement simple.
> - **Tests ajoutés :** `ContratServiceTest.search_shouldBreakTiesOnDraftNumberWhenSortingByOfficialNumber`. Il échouait avant la correction.
> - **Vérification en direct, après redémarrage :** tri ascendant `Brouillon 5, Brouillon 10, CO/55, CO/55/88, CO/877, CO/88/SP`, tri descendant dans l'ordre inverse. Clic réel sur l'en-tête « Contrat » dans l'écran : la liste se trie comme prévu.
> - **Build :** `npm run build` passe. Les tests frontend du module ont les mêmes 14 échecs qu'avant.

- **Constat :** la colonne « Contrat » affiche `numeroOfficiel`, ou « Brouillon N » si ce numéro est absent. Mais son tri porte sur `numeroBrouillon`, qui est vide pour les contrats officiels (`contrat-data-table.component.ts`, colonne `REQUIRED_CONTRAT_COLUMN`).
- **Mesure :** `sort=numeroBrouillon,asc` renvoie `CO/88/SP`, puis `CO/55`, puis `Brouillon 5`. L'ordre des officiels est arbitraire.
- **Scénario :** cliquer sur l'en-tête « Contrat ». Les lignes ne suivent ni l'ordre du numéro affiché ni un ordre logique.
- **Conséquences si on laisse :** le tri de la colonne principale ne sert à rien pour les officiels. L'utilisateur ne peut pas retrouver un contrat en triant, et le tri paraît cassé.

### ANO-03 : 11 tests unitaires de la liste échouent

> **Statut : réglée le 2026-10-10 (liste, page et création).**
>
> Les specs des tests ont été mis à jour pour suivre le code, sans changer ce qui est vérifié :
> - **Mocks manquants :** `getContratsStats` et `getTypes` ajoutés aux mocks de `ContratHttpService` (`contrat-list-view.component.spec.ts`, `contrat-page.component.spec.ts`). Le composant appelle ces méthodes à l'affichage.
> - **Argument en plus :** `searchContrats` reçoit maintenant `serviceGestionnaire` en 11e position. Les 2 assertions attendent `undefined` à cette place, car aucun filtre service n'est actif.
> - **Libellé de l'onglet :** le test attendait « Contrats », le code affiche « Contrat » (`title` et `aria-label` de l'onglet). Test aligné sur le code. **À valider :** si « Contrats » est le libellé voulu, c'est le code qu'il faut changer.
> - **Sélecteur :** `app-page-hero` remplacé par `app-module-page-heading`, le composant effectivement rendu.
>
> Résultat : liste et page passent. Le spec de création a été analysé séparément (voir ci-dessous) : ses 3 échecs sont corrigés.

> **Échecs du spec de création, analysés le 2026-10-10 :**
> - **Catalogue des biens non chargé après une erreur « zéro bien » :** défaut réel. `applySubmissionErrors` change d'étape directement, sans le chargement fait par `goToStep`. Corrigé : le catalogue se charge aussi dans ce cas.
> - **Expiration hors plage (`dateEffet` 9999-12-31) envoyée à l'API :** validation absente. Corrigé : le formulaire refuse une échéance qui dépasse le 31/12/9999, avec un message sur la date d'effet.
> - **Appel d'offres sans numéro envoyé à l'API :** règle décidée le 2026-10-10 : le numéro d'appel d'offres est **obligatoire** en mode « Appel d'offres ». Corrigé côté formulaire (`validateFrontend`) et côté backend (`ContratService.create` et `update`, via `validateNumeroAoForAppelOffres`). Test backend ajouté : `ContratServiceTest.create_shouldRejectAppelOffresWithoutNumeroAo`. Vérifié en direct : l'API renvoie une erreur sur le champ `numeroAo`, et aucun contrat n'est créé.
> - **Note :** la règle est renvoyée en 422 (comme les autres erreurs de validation de champ), alors que `ContratTransitionIntegrationTest` attend 400. C'est l'un des 3 échecs déjà connus côté backend.
>
> **Résultat final :** le module contrat passe 86 tests frontend sur 86. Côté backend, 88 tests, dont 3 échecs connus dans `ContratTransitionIntegrationTest`.

- **Constat :** `npm test` sur le module contrat donne 14 échecs sur 85. Les 11 de la liste et de la page ont la même erreur affichée : `this.contratHttpService.getContratsStats is not a function`. Le mock de test ne contient plus la méthode `getContratsStats`, que le composant appelle désormais. Les 3 échecs de la création n'ont pas été analysés.
- **Scénario :** lancer `npm test` sur le module contrat. Les tests de liste (tri, pagination, recherche, export, suppression) sont rouges.
- **Conséquences si on laisse :**
  - Une régression sur la liste ne sera pas détectée.
  - Une CI bloquée ou ignorée finit par être désactivée.
  - Les tests ne reflètent plus le code, et personne ne sait lesquels faire confiance.
- **Remarque :** les 8 échecs du spec de la liste n'affichent que cette erreur dans la sortie. Je ne l'ai pas vérifié test par test.

### ANO-04 : Si les stats échouent, les KPI affichent 0

> **Statut : réglée le 2026-10-10.**
>
> - **Correction :** en cas d'échec de `/stats`, les 6 indicateurs affichent « — » (`statsUnavailable`, `unavailableStatValue`, `clientAirportSummary`), et un toast d'avertissement est affiché. La liste reste affichée. Un chargement réussi remet les indicateurs à leur valeur.
> - **Test ajouté :** `ContratListViewComponent` « n'affiche pas de 0 quand les statistiques ne peuvent pas être chargées ». Il échouait avant la correction.
> - **Vérification en direct :** en faisant échouer l'appel `/stats` dans le navigateur, puis en déclenchant une recherche, les indicateurs affichent « — », le toast « Indicateurs indisponibles » apparaît, et la liste reste visible.
> - **Build et tests :** `npm run build` passe, et les 87 tests frontend du module passent.

- **Constat :** en cas d'erreur sur `/stats`, `loadStats` met `stats` à `null`. Le template écrit alors `stats()?.total ?? 0`, donc chaque KPI affiche 0. Aucun message n'est donné.
- **Scénario :** `/stats` renvoie une erreur (service coupé, 500). La page affiche « Total contrats : 0 », « Officiels : 0 », etc., alors que la liste contient des contrats.
- **Conséquences si on laisse :** un chiffre faux (0) passe pour un vrai, et une direction peut le lire comme une absence d'activité.

### ANO-05 : Chercher « Brouillon » seul ne renvoie rien

> **Statut : réglée le 2026-10-10.**
>
> - **Règle décidée :** « Brouillon » seul désigne les contrats affichés « Brouillon N », c'est-à-dire sans numéro officiel. Le numéro de brouillon ne peut pas servir de critère, car tous les contrats en ont un.
> - **Correction :** `ContratSpecification` applique ce filtre quand le mot saisi est « brouillon ». Les autres recherches ne changent pas.
> - **Test ajouté :** `ContratSpecificationTest.rechercheBrouillonSeulRendLesContratsSansNumeroOfficiel`. Il échouait avant la correction.
> - **Vérification en direct :** « Brouillon » renvoie les 2 brouillons, « Brouillon 10 » renvoie le seul contrat concerné, « CO/55 » inchangé.

- **Constat :** le backend retire le préfixe `brouillon ` (avec un espace) avant de chercher sur `numeroBrouillon`. Le mot seul ne déclenche pas ce retrait, et il est cherché tel quel.
- **Mesure :** `keyword=brouillon` renvoie 0 résultat. La ligne affiche pourtant « Brouillon 10 ».
- **Scénario :** taper « Brouillon » dans la recherche. Le tableau est vide. Taper « Brouillon 10 » fonctionne.
- **Conséquences si on laisse :** l'utilisateur croit qu'il n'y a aucun brouillon, alors que la recherche fonctionne avec le numéro seul.

### ANO-06 : L'export fait 4 requêtes par ligne, sans limite

> **Statut : réglée le 2026-10-10.**
>
> - **Correction :** `ContratService.exportToExcel` charge les biens, prestations, cautions et pièces jointes de tous les contrats trouvés par lots (`loadChildrenByContratId`). Le nombre de requêtes ne dépend plus du nombre de contrats : une requête par type d'enfant et par lot de 1000 contrats. Le lot de 1000 évite la limite de 2100 paramètres de SQL Server.
> - **Repositories :** un finder `findByContratIdInOrderByCreatedAtAsc` ajouté pour chacun des 4 types d'enfant.
> - **Tests ajoutés :** `exportToExcel_shouldLoadChildrenInBatchesNotPerContract` (échouait avant la correction) et `exportToExcel_shouldSplitLargeExportsIntoBatches` (1001 contrats, 2 lots).
> - **Vérification en direct :** l'export répond 200 avec le bon type de fichier, avec et sans filtre.
> - **Limite :** je n'ai pas mesuré le temps d'export à grand volume, pour ne pas écrire de données de test en base sans votre accord. Le gain attendu est dans le nombre de requêtes, testé en unitaire.

- **Constat :** `exportToExcel` boucle sur chaque contrat et appelle 4 repositories (biens, services, cautions, pièces jointes). Il n'y a aucune limite de volume.
- **Scénario :** exporter une liste de plusieurs milliers de contrats.
- **Conséquences si on laisse :** temps de réponse qui grimpe avec le volume, risque de timeout (le frontend coupe à 15 secondes sur la liste), charge inutile sur la base. Non mesuré, donc à confirmer avec un volume réel.

### ANO-07 : Un tri sur un champ inconnu renvoie une 500

> **Statut : réglée le 2026-10-10.**
>
> - **Correction :** `ContratService.validateSortFields` refuse, avant la requête, tout champ de tri hors liste blanche (`annee`, `numeroBrouillon`, `numeroOfficiel`, `clientRaisonSocialeSnapshot`, `statut`, `dateEffet`, `dateExpiration`). Appliqué à la liste, à la recherche et à l'export.
> - **Test ajouté :** `ContratServiceTest.search_shouldRejectSortOnUnknownField`. Il échouait avant la correction.
> - **Vérification en direct :** un tri sur `champInexistant` renvoie 400 avec le message « Tri impossible sur le champ « champInexistant ». », sur la liste comme sur l'export. Un tri valide (`statut`) renvoie toujours 200.

- **Mesure :** `GET /api/contrats?sort=champInexistant,asc` renvoie 500, et `/search` pareil.
- **Scénario :** un appel direct à l'API avec un champ de tri inventé. Le frontend ne le permet pas, car il ne propose que des colonnes connues.
- **Conséquences si on laisse :** un 500 est une erreur serveur, qui brouille les alertes et les journaux. Une 400 explicite serait plus claire.

### ANO-08 : Le caractère `%` dans la recherche renvoie tout

- **Mesure :** `keyword=%` renvoie les 7 contrats. `keyword=_` renvoie aussi les 7.
- **Scénario :** taper `%` ou `_` dans la recherche.
- **Conséquences si on laisse :** la recherche renvoie des résultats qui ne correspondent pas à la saisie. Il n'y a pas d'injection (les valeurs sont paramétrées), donc le risque est sur la pertinence des résultats.

### ANO-09 : Paramètres invalides ignorés en silence

- **Mesure :**
  - `expirationStatus=N_IMPORTE_QUOI` : la liste n'est pas filtrée (7 résultats).
  - `page=-1` : traité comme la page 0.
  - `size=0` et `size=-5` : traités comme 20.
  - `size=100000` : plafonné à 2000 sans avertissement.
- **Scénario :** un appel avec une valeur mal formée, ou une URL bricolée.
- **Conséquences si on laisse :** l'appelant croit avoir un filtre appliqué alors qu'il ne l'est pas. Un bug côté frontend passe inaperçu.

### ANO-10 : Les stats chargent tous les contrats en mémoire

- **Constat :** `getStats` appelle `repository.findAll(specTotal)` pour compter les clients distincts, et fait 5 requêtes `count`. Cela se fait à chaque changement de la liste.
- **Scénario :** avec un volume important de contrats, chaque changement de filtre charge toute la liste en mémoire.
- **Conséquences si on laisse :** la page devient lente quand le volume grossit. À 7 contrats, cela ne se voit pas.

### ANO-11 : Le filtre client ne propose que les 100 premiers clients

- **Constat :** le composant charge les clients avec `size: 100`, sans pagination ni recherche distante (`loadFilterOptions`).
- **Scénario :** avec plus de 100 clients, le client 101 n'apparaît pas dans le filtre, et ses contrats ne peuvent pas être filtrés.
- **Conséquences si on laisse :** des contrats deviennent introuvables par filtre, sans message d'erreur.

### ANO-12 : Un composant de liste mort, qui duplique le code

- **Constat :** `ContratListTabComponent` (`contrat-list-tab.component.ts`, 3910 lignes) est déclaré, mais aucune route ni aucun template ne l'utilise. La page passe par `ContratListViewComponent`. Le composant mort contient pourtant sa propre liste et ses propres actions (transitions, suppression).
- **Scénario :** corriger un bug de liste dans le composant mort, alors que la page affiche l'autre.
- **Conséquences si on laisse :** correction au mauvais endroit, code difficile à lire, et tests qui pointent vers un composant qui ne sert pas.

### ANO-13 : Le tri sur « Statut » ne suit pas le cycle de vie

- **Mesure :** `sort=statut,desc` renvoie `RESILIE`, puis `OFFICIEL`, puis `OFFICIEL`. Le tri suit le code en lettres.
- **Scénario :** trier la colonne Statut.
- **Conséquences si on laisse :** le tri ne reflète pas l'avancement du contrat, comme le demande la fonctionnalité « améliorer la liste pour voir l'avancement ».

### ANO-14 : À chaque frappe, les indicateurs clignotaient

> **Statut : réglée le 2026-10-10.** Trouvée pendant la correction d'ANO-05, à partir du retour utilisateur sur un « glitch » à chaque frappe.
>
> - **Constat :** à chaque requête de recherche, `loadStats` remettait `statsLoading` à `true`. Les 6 cartes KPI passaient alors en squelette animé, et leurs valeurs disparaissaient puis réapparaissaient. Vérifié en direct avec un `MutationObserver` : squelettes détectés à chaque frappe.
> - **Correction :** le squelette ne s'affiche que s'il n'existe encore aucune valeur (`statsLoading` = `stats() === null`). Pendant une recherche, les chiffres déjà affichés restent en place.
> - **Test ajouté :** `ContratListViewComponent` « garde les indicateurs affichés pendant une nouvelle recherche ». Il échouait avant la correction.
> - **Vérification en direct :** après correction, aucun squelette KPI pendant la saisie.
> - **Reste volontaire :** le petit spinner de la loupe dans la barre de recherche apparaît pendant la requête. C'est un indicateur de recherche en cours, pas un clignotement. À retirer si vous le trouvez gênant.
> - **Cause annexe :** un backend bloqué (`operation-service` qui n'a pas redémarré après mes `mvn test`) laissait l'overlay « Chargement… » affiché en permanence. Ce n'est pas un défaut du code, mais un piège de développement. Le service a été relancé.

### ANO-19 : Le tri par période de validité ne suit pas les dates affichées

> **Statut : réglée le 2026-10-10. Évolution : le tri porte maintenant sur la date de début (première date affichée), et non plus sur la date de fin.**
>
> - **Évolution :** la colonne « Période de validité » trie sur `dateEffet`, la date de début. Le tri sur la date de fin, et la colonne calculée qui le faisait (`dateExpirationAffichee`), sont retirés.
> - **Vérification :** tri ascendant et descendant à l'écran, dans l'ordre des dates de début. Test backend `triParDateDeDebut_ordonneLesContratsParDateEffet`. Suite backend : 103 tests, dont seulement les 3 échecs connus. Frontend : 136 tests, build OK.
>
> *Historique de la correction précédente (option 2) :*
>
> - **Correction :** `ContratEntity` a une colonne calculée en lecture seule, `dateExpirationAffichee` (`@Formula`). Elle applique la même règle que `getDateExpiration()` : date d'effet du contrat racine, puis durée, puis un jour de moins. Le tri `dateExpiration` demandé par le frontend est traduit vers cette colonne (`ContratService.toEntitySort`), dans la liste et dans l'export. La colonne `date_expiration`, utilisée par les alertes, n'est pas modifiée. Aucune modification de base.
> - **Pourquoi les jointures ont changé :** la première version échouait en SQL Server (« ORDER BY items must appear in the select list if SELECT DISTINCT is specified »). Le `DISTINCT` venait des jointures sur les aéroports. Le filtre et la recherche par aéroport passent désormais par des sous-requêtes `EXISTS`, sans `DISTINCT`. Les résultats sont identiques (vérifié).
> - **Tests ajoutés :** `ContratSpecificationTest.triParEcheanceAffichee_utiliseLeContratRacinePourUnAvenant`. Il échouait avant la correction.
> - **Vérification en direct :** le tri ascendant et descendant de l'API suit les dates affichées. À l'écran, les dates de fin sont dans l'ordre dans les deux sens.
> - **Build et tests :** suite backend du module : 103 tests, dont seulement les 3 échecs connus de `ContratTransitionIntegrationTest`.
>
> *Analyse initiale conservée :*

> **Statut : cause confirmée le 2026-10-10. Décision métier en attente, aucune correction faite.**
>
> - **Ce qui est correct :** le tri SQL. La colonne `date_expiration` (calculée en base à partir de la date d'effet et de la durée du contrat, et indexée) est bien triée. Vérifié en lecture seule sur la table `dbo.contrats`.
> - **Ce qui diverge :** la date affichée. `ContratEntity.getDateExpiration()` recalcule la date à partir de la date d'effet du contrat racine, pour les avenants. Exemple : `CO/88/SP` avenant 2 a une date en base de 31/12/2028, et l'écran affiche 31/12/2027. `CO/55/88` avenant 1 : base 31/05/2029, écran 31/12/2028. Le tri suit la base, l'affichage suit le contrat racine, donc l'ordre paraît faux.
> - **Pourquoi c'est important :** la colonne en base est aussi celle de l'index d'alerte d'échéance (`IX_contrats_expiration`). Une date affichée différente de celle qui déclenche les alertes est un problème à part entière.
> - **Deux corrections possibles, à choisir :**
>   1. Afficher la date en base. Tri et affichage deviennent cohérents, et alertes et écran utilisent la même date. Les avenants affichent alors leur propre échéance, ce qui change ce qu'ils montrent aujourd'hui.
>   2. Garder l'affichage actuel, et trier sur la date du contrat racine. Pas de changement de base, mais une expression de tri plus complexe, et les alertes restent sur l'autre date.
> - **Recommandation :** option 1, puisque la base et les alertes utilisent déjà cette date. À confirmer par le responsable du module, car c'est une règle métier.

### ANO-17 : Le tiroir des filtres avancés est vide

> **Statut : réglée le 2026-10-10.**
>
> - **Cause :** la liste ouvrait le tiroir sans contenu. Les options existaient dans la classe, mais aucun contrôle n'était rendu. Il n'existait pas non plus de méthode pour poser une valeur de filtre : la liste savait seulement retirer un filtre ou tout réinitialiser.
> - **Correction :** nouveau composant `ContratFilterPanelComponent` (`components/contrat-filter-panel.component.ts`), sur le modèle du panneau des aéroports. Il rend 6 sélecteurs (statut, type, client, aéroport, échéance, service). Chaque choix est remonté à la liste, qui revient à la page 1 et relance la recherche. La liste reçoit la nouvelle méthode `onFiltersChange`.
> - **Tests ajoutés :** `affiche les six filtres avancés dans le tiroir` et `applique immédiatement un filtre choisi dans le tiroir`. Ils échouaient avant la correction.
> - **Vérification en direct :** le tiroir affiche 6 sélecteurs. Le choix « Officiel » ramène 3 contrats (CO/877, CO/55/88, CO/88/SP), comme l'API, et la puce « Statut : Officiel » s'affiche. « Réinitialiser » ramène les 6 contrats.
> - **Choix d'aéroports multiples (décision du 2026-10-10) :** l'API accepte désormais plusieurs aéroports (`aeroportId` répété) sur la recherche, les stats et l'export. Un aéroport inconnu renvoie 0. Le champ passe en puces (`app-multi-select-chips`). Vérifié à l'écran : « Aeroport Rabah Bitat » ramène 2 contrats.
> - **Bascules :** l'échéance (Déjà expiré, Échéance 3 mois, Échéance 6 mois) et le service gestionnaire sont des bascules. Le service passe en bascules sur 2 colonnes.
> - **Tous les filtres joués à l'écran :** statut, type, client, aéroports, échéance, service. Chacun renvoie le compte de l'API, la puce s'affiche, et « Tout effacer » remet les 6 contrats.
> - **Build et tests :** `npm run build` passe, et les 99 tests frontend du module passent.

### ANO-18 : Les tris Client et Statut semblaient sans effet

> **Statut : clôturée le 2026-10-10 (non reproduite), sur accord de l'utilisateur.**
>
> - **Ce que j'ai vérifié :** de vrais clics sur les en-têtes, aux coordonnées réelles de la fenêtre. Client : ascendant puis descendant, avec l'ordre affiché cohérent. Statut : ascendant, avec l'ordre affiché cohérent. Les requêtes partent avec le bon champ de tri (`clientRaisonSocialeSnapshot`, `statut`), et l'API trie correctement. Le tri pendant une recherche active fonctionne aussi, et le troisième clic annule le tri.
> - **Pourquoi le défaut paraissait réel :** lors de la première série, mes clics étaient décalés et tombaient sur des en-têtes voisins (un clic sur Client a déclenché un tri sur Statut). Le défaut venait donc probablement de mon outil de test, pas de l'application. Je ne peux pas l'affirmer à 100 %, car je n'ai pas retrouvé la séquence exacte qui l'avait produit.
> - **Aucune correction de code n'a été faite**, car aucun défaut n'a été trouvé dans le code.

### ANO-15 : La recherche cherchait dans des champs non affichés, et « Br » ne renvoyait rien

> **Statut : réglée le 2026-10-10.**
>
> - **Constat :** « co » faisait apparaître le Brouillon 5, dont l'objet « occupation de compteur » contient « co ». L'objet n'est pas affiché dans la liste, donc la ligne semblait sortir de nulle part. « Br » ne renvoyait rien, car le libellé « Brouillon N » n'était pas cherché.
> - **Règles décidées :**
>   - la recherche ne couvre que les champs affichés : numéro officiel, numéro de brouillon, client et aéroport ;
>   - un début de « Brouillon » (2 lettres ou plus, par exemple « br », « bro ») ramène les contrats affichés « Brouillon N ».
> - **Correction :** `ContratSpecification` (objet, titre et numéro d'AO retirés de la recherche, nom de l'aéroport ajouté, et règle du début de « Brouillon »).
> - **Tests ajoutés :** `rechercheDebutDeBrouillonRendLesBrouillons`, `rechercheNeCherchePasDansLObjetDuContrat`, `rechercheParNomDAeroportDuContrat`. Ils échouaient avant la correction.
> - **Vérification en direct :** « br » et « bro » renvoient les 2 brouillons, « co » ne renvoie plus le Brouillon 5, « Air » renvoie les contrats du client Air Algerie, « brouillon 10 » et « CO/55 » inchangés.

## 6. Points testés sans anomalie

- Requête sans jeton : 401.
- Enum de statut invalide (`statut=INVALIDE`) : 400.
- UUID de client invalide : 400.
- Mot-clé de 3000 caractères : 200, sans erreur.
- Apostrophe dans la recherche : 200, sans erreur.
- Page hors plage (`page=999999`) : 200, liste vide.
- Export sans filtre : 200, bon type de fichier (xlsx).
- Export avec statut invalide : 400.

## 7. Limites de cet audit

- Un seul compte testé (`test`, rôle commercial). Les droits des autres rôles n'ont pas été vérifiés.
- Les volumes sont très faibles (7 contrats). Les anomalies de performance (ANO-06, ANO-10) sont lues dans le code, pas mesurées.
- L'export n'a pas été téléchargé ni ouvert pour vérifier son contenu.
- Les clics ont été joués sur quelques éléments seulement (ouverture d'un détail, onglets). Les actions d'écriture (suppression d'un brouillon, transitions) n'ont pas été jouées, faute d'accord.
- ANO-04 n'a pas été reproduit en coupant le service.

## 8. Avancement

**Au 2026-10-10 (fin de session).** 19 anomalies : 11 réglées, 1 clôturée (ANO-18, non reproduite), 7 ouvertes, toutes mineures.

| Ouvertes | Sujet | Notes |
| --- | --- | --- |
| ANO-08 | `%` et `_` non échappés dans la recherche | Reproduit (test E-6) |
| ANO-09 | Paramètres invalides ignorés en silence | |
| ANO-10 | Stats qui chargent tous les contrats en mémoire | Lu dans le code |
| ANO-11 | Filtre client limité aux 100 premiers clients | Lu dans le code. Défaut fonctionnel dès 100 clients |
| ANO-12 | Composant mort `contrat-list-tab` | Son fichier a dû être adapté pour que le build passe |
| ANO-13 | Tri par statut sans ordre du cycle de vie | |
| ANO-16 | Message trompeur quand une recherche ne renvoie rien | Reproduit (test E-1) |

**Hors anomalies, à trancher :**
- Test E-5 : le changement de taille de page au clic ne répond pas dans l'outil de test, alors que le clavier fonctionne. À vérifier à la main avant d'en faire une anomalie.
- Tests bloqués : Modifier et Supprimer un brouillon (aucun brouillon en base), et Export (téléchargement soumis à votre accord).

**Changements de la session à connaître :**
- Le tri « Période de validité » porte sur la date de début (`dateEffet`).
- L'API accepte plusieurs aéroports, et le filtre Aéroports est en puces.
- Les filtres Échéance et Service gestionnaire sont des bascules, avec les libellés « Déjà expiré », « Échéance 3 mois », « Échéance 6 mois ».
- Les filtres statut, type, client, aéroports, échéance et service ont été joués à l'écran.

**Reprise :** commencer par ANO-08 (`ContratSpecification`, recherche par mot-clé), puis ANO-16 (message de la liste) pour lever les deux échecs du fichier de test.
