FROM node:12.18 AS base
WORKDIR /app

# -----Dependecies------
FROM base AS dependecies
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm ci

# -----Copy Files/Build------
FROM dependecies as build
WORKDIR /app
COPY /src ./src
RUN npm run build

# ---Realese with Alpine----
FROM node:12.18-alpine
WORKDIR /app
COPY --from=dependecies /app/package*.json ./
RUN npm ci --production && npm cache clean --force
COPY --from=build /app/dist ./dist

ENV PORT=8080
EXPOSE 8080
CMD ["node", "dist/main.js"]