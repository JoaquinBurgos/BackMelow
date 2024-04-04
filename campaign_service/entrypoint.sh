#!/bin/bash
set -e

# Verificar que Postgres está listo antes de continuar
ruby <<SCRIPT
require 'pg'
begin
  conn = PG.connect(dbname: '${POSTGRES_DB}', user: '${POSTGRES_USER}', password: '${POSTGRES_PASSWORD}', host: 'db')
rescue PG::ConnectionBad
  puts 'Postgres no está listo aún. Esperando...'
  sleep 1
  retry
end
puts 'Postgres está listo.'
SCRIPT

# Ejecutar el comando pasado al contenedor
exec "$@"
