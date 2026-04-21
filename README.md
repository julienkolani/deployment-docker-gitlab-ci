# Deployment Docker GitLab CI

A complete deployment infrastructure for a Django + static frontend web application. Features multi-stage Docker builds, a GitLab CI/CD pipeline with check, package, delivery, and cleanup stages, Nginx Unit as the ASGI server for the Django backend, and SSH-based deployment to dev and prod environments.

## Features

- Multi-stage Dockerfile for Django with Nginx Unit (ASGI)
- GitLab CI/CD pipeline: check, package, delivery, cleanup stages
- Dev and prod deployment targets via SSH
- Static vitrine site and mobile app landing page, each with their own Nginx container and pipeline
- Node.js frontend with Nginx reverse proxy
- Docker entrypoint script for Django initialization

## Tech Stack

- Python / Django
- Nginx Unit (ASGI server)
- Nginx
- Docker (multi-stage builds)
- GitLab CI/CD
- SSH deployment

## Setup

Each subdirectory contains its own `Dockerfile` and `.gitlab-ci.yml`. Configure CI/CD variables in your GitLab project settings (SSH keys, registry credentials, environment URLs).

Build locally:

```bash
cd back
docker build -t django-backend .
```

## Project Structure

```
back/
  Dockerfile                          # Multi-stage Django + Nginx Unit image
  docker_entrypoint.sh                # Entrypoint: migrations, static files, start
  .gitlab-ci.yml                      # Backend CI/CD pipeline
  django-nginx-unit/configurations/   # Nginx Unit config and CI env template
front/
  DeployAppSite/                      # Mobile app landing page (static site + Nginx)
  nodejs/                             # Node.js frontend with Nginx
  site_vitrine/                       # Static vitrine site with Nginx
```
