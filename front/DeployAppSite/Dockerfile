FROM nginx:latest

WORKDIR /usr/share/nginx/html

# Copier le contenu du répertoire courant dans le répertoire html de Nginx
COPY . /usr/share/nginx/html/

# Renommer les fichiers APK
RUN mv /usr/share/nginx/html/apk/app-arm64-v8a-release.apk /usr/share/nginx/html/apk/app-arm64.apk \
 && mv /usr/share/nginx/html/apk/app-armeabi-v7a-release.apk /usr/share/nginx/html/apk/app-armeabi.apk \
 && mv /usr/share/nginx/html/apk/app-x86_64-release.apk /usr/share/nginx/html/apk/app-x86_64.apk

RUN chown -R nginx:nginx /usr/share/nginx/html

RUN chmod 644 /usr/share/nginx/html/apk/*.apk

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf
