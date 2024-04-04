# Usar la imagen oficial de Ruby como imagen base
FROM ruby:3.0.0

# Instalar dependencias para Rails
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Definir el directorio de trabajo dentro del contenedor
WORKDIR /myapp

# Copiar el Gemfile y Gemfile.lock e instalar las gemas
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Copiar el proyecto entero al contenedor
COPY . /myapp

# Agregar un script para verificar que Postgres está listo antes de conectar
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Iniciar el servidor de Rails en el puerto 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]

