# Deployment Docker GitLab CI

Infrastructure de déploiement complète pour une application web multi-tiers avec Docker multi-stage et pipeline GitLab CI/CD.

## Fonctionnalités

- Dockerfile multi-stage : lint → build → image de production
- Pipeline GitLab CI en 5 étapes : vérification, packaging, livraison, nettoyage
- Déploiement SSH automatique vers les environnements dev et prod
- Backend Django avec Nginx Unit (serveur ASGI)
- Frontend statique et application mobile

## Stack technique

- Django, Docker multi-stage, Nginx Unit
- GitLab CI/CD, SSH

## Structure

- `back/` — Backend Django avec Dockerfile et configuration Nginx Unit
- `front/` — Frontend statique, Node.js, site vitrine
