# Limpiar todos los usuarios y actividades
UserCampaignProgress.destroy_all
UserActivity.destroy_all
User.destroy_all

# Crear usuarios
user1 = User.create(name: 'Usuario Uno', email: 'jlburgos@uc.cl')
user2 = User.create(name: 'Usuario Dos', email: 'burgosfernandezjoaquin@gmail.com')

# Imprimir en la consola que las seeds han sido creadas
puts 'Se han creado las seeds de usuarios id: ' + user1.id.to_s + ' y ' + user2.id.to_s + '.'
