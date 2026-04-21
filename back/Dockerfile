FROM debian:stable-slim as check

RUN mkdir -p /home/app

WORKDIR /home/app/

# Installation des outils nécessaires
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -y && \
    apt-get -o APT::Install-Recommends=false upgrade -y && \
    apt-get install -y \
        python3 \
        python3-venv \
        python3-pip \
        libpq-dev \
        python3-dev \
        build-essential pkg-config libxml2-dev libxmlsec1-dev libxmlsec1-openssl && \
    apt-get autoremove -y

# Création de l'environnement virtuel
RUN python3 -m venv /home/app/venv

# Copie des fichiers du projet Django dans le conteneur

COPY . /home/app/

# Installation des dépendances Django dans l'environnement virtuel
RUN --mount=type=cache,target=/root/.cache \
    /home/app/venv/bin/pip install -r /home/app/requirements.txt  && \
    ls configurations/.ci_env && ls && pwd && \
    if [ -e configurations/.ci_env ]; then \
        mv configurations/.ci_env .env; \
        cat .env; \
    fi

RUN /home/app/venv/bin/python3 /home/app/manage.py check

# Étape 1 : Construction de l'environnement virtuel et installation des dépendances Django
FROM debian:stable-slim AS builder

WORKDIR /home/app/

RUN mkdir -p /home/app

# Copie des fichiers du projet Django dans le conteneur
COPY requirements.txt /home/app/requirements.txt

# Installation des outils nécessaires
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -y && \
    apt-get -o APT::Install-Recommends=false upgrade -y && \
    apt-get install -y \
        python3 \
        python3-venv \
        python3-pip \
        libpq-dev \
        python3-dev \
        build-essential pkg-config libxml2-dev libxmlsec1-dev libxmlsec1-openssl && \
    apt-get autoremove -y

# Création de l'environnement virtuel
RUN python3 -m venv /home/app/venv

# Installation des dépendances Django dans l'environnement virtuel
RUN --mount=type=cache,target=/root/.cache \
    /home/app/venv/bin/pip install -r /home/app/requirements.txt

# Étape 2 : Création du conteneur final
FROM debian:stable-slim AS containerize

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get -o APT::Install-Recommends=false upgrade -y && \
    apt-get install -y curl libxml2 libxmlsec1-openssl && \
    apt-get autoremove -y && \
    curl --output /usr/share/keyrings/nginx-keyring.gpg https://unit.nginx.org/keys/nginx-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bookworm unit" > /etc/apt/sources.list.d/unit.list && \
    apt-get update && \
    apt-get install -y -o APT::Install-Recommends=false unit unit-python3.11 python3

COPY --from=builder /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/libpq.so.5 /usr/lib/x86_64-linux-gnu/

RUN ln -sf /dev/stdout /var/log/unit.log

# Copie de l'environnement virtuel depuis l'étape précédente builder
COPY --chown=unit:unit --from=builder /home/app/venv /home/app/venv

# variables d'environnement
ENV PATH="/home/app/venv/bin:$PATH"

WORKDIR /home/app/application_api

EXPOSE 80

COPY --chown=unit:unit . .
RUN chmod +x docker_entrypoint.sh && chown unit:unit -R .

ENTRYPOINT ["/home/app/application_api/docker_entrypoint.sh"]

# Commande CMD corrigée
CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]
