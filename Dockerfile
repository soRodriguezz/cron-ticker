# imagen base
FROM node:19.2-alpine3.16

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

# copia todo a workdir
COPY . .

# Ejecutar test
RUN npm run test

# Eliminar archivos y directorios no necesarios en PROD
RUN rm -rf test && rm -rf node_modules

# Intalar dependecias de produccion
RUN npm install --prod

# comando para levantar app
CMD [ "npm", "start" ]