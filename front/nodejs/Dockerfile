FROM node:20 AS check

WORKDIR /apps/frontend

COPY package.json .

RUN --mount=type=cache,target=/root/.npm npm install -f

COPY . .

FROM node:20 AS buildenv

WORKDIR /apps/frontend

COPY package.json .

RUN --mount=type=cache,target=/root/.npm npm install -f

COPY . .

RUN npm run build

FROM nginx:stable-alpine AS containerize
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=buildenv /apps/frontend/build/ /usr/share/nginx/html/
