FROM node:22 AS build

WORKDIR /app

COPY . .

# RUN npm run generate-api
RUN npm i && npm run build
RUN npm prune --production

# ------------------
FROM node:22 AS run

ENV NODE_ENV=production

WORKDIR /app
COPY --from=build /app .
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/node_modules ./node_modules

RUN ulimit -c unlimited

LABEL maintainer="Aaron Pritzlaff <aaron@kindservices.co.uk>"
LABEL usage="docker run -p 3000:3000 docker.io/kindservices/my-app-name:latest"
LABEL version="0.0.1"
LABEL org.opencontainers.image.source="https://github.com/aaronp/my-app-name"
LABEL org.opencontainers.image.url="https://kindservices.co.uk"
LABEL license="Apache-2.0"
LABEL vendor="Kind Services Ltd"


VOLUME ["/app/data", "/app/output", "/app/imports"]

ENTRYPOINT ["node", "build"]
