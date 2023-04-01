
# Dependencias de desarrollo
FROM node:19.2-alpine3.16 as deps

# hacer build para una plataforma especifica en cmd
# FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16

# Para declarar una plataforma de compilación
# FROM --platform=arm64 node:19.2-alpine3.16

#  cd para /app
WORKDIR /app

# copiar archivos de la carpeta actual a /app
COPY package.json ./

# instalar dependencias
RUN npm install

# copiar todo a /app
FROM node:19.2-alpine3.16 as builder

WORKDIR /app

# Desde el stage deps toma el node_modules generado y lo pasa a esta etapa
COPY --from=deps /app/node_modules ./node_modules

# copia todo a workdir
COPY . .

# Ejecutar test
RUN npm run test

# Ejecutar build de produccion
FROM node:19.2-alpine3.16 as deps-prod
WORKDIR /app
COPY package.json ./
RUN npm install --prod

# Para ejecutar la app
FROM node:19.2-alpine3.16 as runner
WORKDIR /app
COPY --from=deps-prod /app/node_modules ./node_modules
COPY app.js ./
COPY tasks ./tasks
# comando para levantar app
CMD [ "npm", "start" ]