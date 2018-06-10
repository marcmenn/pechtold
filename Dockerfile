FROM node:6
FROM node:6 AS build
RUN mkdir -p /opt/pechtold
WORKDIR /opt/pechtold
COPY package.json npm-shrinkwrap.json ./
RUN npm install
COPY docpad.coffee ./
COPY plugins ./plugins
COPY src ./src
RUN ./node_modules/.bin/docpad generate --env static --silent

FROM nginx:stable-alpine
#COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /opt/pechtold/out /usr/share/nginx/html
