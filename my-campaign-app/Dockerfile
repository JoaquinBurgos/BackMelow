# Utiliza una imagen base de Node
FROM node:14

# Define el directorio de trabajo en el contenedor
WORKDIR /app

# Copia el package.json y package-lock.json (si está disponible)
COPY package*.json /app/

# Instala las dependencias del proyecto
RUN npm install

# Copia el resto de los archivos del proyecto al contenedor
COPY . /app

# Expone el puerto en el que tu aplicación se ejecutará
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["npm", "start"]
