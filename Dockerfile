# Especificar la imagen base a utilizar
FROM node:20

# Seleccionar directorio de trabajo por defecto
WORKDIR /opt/app

# Copiando el contenido local al contenedor
COPY . .

# Instalando dependecias necesarias
RUN npm install

# Compilar la aplicacion
RUN npm run build

# Define comando de entrada al contenedor
CMD npm run start:prod
