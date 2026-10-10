# EGSA_ERP

ERP interne de l'EGSA (gestion aéroportuaire) : référentiel, opérations, commercial, facturation.

## Stack

- **Frontend** `EGSA_ERP_Frontend/` : Angular 21 (standalone), PrimeNG + PrimeIcons, Tailwind 4, tests Vitest. Port 4200.
- **Backend** `EGSA_ERP_Backend/` : microservices Spring Boot 4.1 (Java 21, Java 17 pour `auth-service`), une base SQL Server par service, authentification Keycloak.

| Service | Port | Base |
|---|---|---|
| `referentiel-service` | 8081 | `egsa_referentiel` |
| `auth-service` | 8082 | `AuthDb` |
| `operation-service` | 8083 | `egsa_operation` |
| `facturation-service` | 8084 | `egsa_facturation` |
| Keycloak (Docker) | 8080 | realm `egsa-erp`, importé depuis `keycloak/import/` |

## Commandes

- Backend, dans le dossier d'un service : `mvn spring-boot:run -Dspring-boot.run.profiles=local`, tests `mvn test`.
- Frontend : `npm start`, vérification `npm run build` (jamais `ng build` seul, voir `.claude/rules/frontend/npm.md`), tests `npm test`.
- Keycloak et outils locaux : `Docker/docker-compose.dev.yml`.

**Ne jamais démarrer un service, le frontend ou un conteneur soi-même.** Donner la commande exacte et laisser l'utilisateur la lancer.

## Où trouver quoi

- Documentation des modules : `ERP_Docs/Modules/<service>/<module>/` (`schema.<module>.md`, `migration.<module>.sql`, `seed.<module>.sql`, `tasks.<module>.txt`, `test.<feature>.txt`). **Commencer par `ERP_Docs/README.md`** : son index donne, pour chaque table, le module et le dossier où elle est décrite.
- Modules de référence, à imiter en priorité : **Aéroport** et **Bien** (`referentiel-service/.../aeroport`, `EGSA_ERP_Frontend/src/app/features/referentiel/Aeroport`). Les autres modules ont de la dette : ne pas les copier par défaut.
- Composants d'interface partagés : `EGSA_ERP_Frontend/src/app/shared/components/`, à relire avant de coder un écran.
- Règles de code : `.claude/rules/` (`backend/`, `frontend/`, et les règles communes à la racine). Elles s'appliquent au code nouveau ; le code existant non conforme est une dette qu'on ne corrige pas sans demande.
