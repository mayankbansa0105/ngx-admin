FROM node:12-slim as build
ENV NG_CLI_ANALYTICS=ci
RUN apt update -y && apt-get install python  -y
WORKDIR /app
COPY . .
RUN   export  NG_CLI_ANALYTICS=ci && npm install && npm run build:prod
FROM nginx:1.20
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/dist /usr/share/nginx/html
HEALTHCHECK CMD curl --fail http://localhost || exit 1
CMD ["nginx", "-g", "daemon off;"]
