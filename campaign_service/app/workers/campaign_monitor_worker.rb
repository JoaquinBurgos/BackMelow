class CampaignMonitorWorker
    include Sidekiq::Worker
  
    def perform
      # Itera a través de cada campaña.
      Campaign.includes(:conditions).find_each do |campaign|
        # Itera a través de cada usuario para verificar las condiciones de la campaña.
        User.find_each do |user|
          process_activities_for_campaign(user, campaign)
        end
      end
    end
  
    private
  
		def process_activities_for_campaign(user, campaign)
			user_progress = UserCampaignProgress.find_by(user: user, campaign: campaign)
	
			# Si no hay progreso y las condiciones se cumplen, crea el progreso.
			if user_progress.nil?
				if all_conditions_met?(user, campaign)
					user_progress = UserCampaignProgress.create(
						user: user, 
						campaign: campaign, 
						node: campaign.first_node, 
						last_updated_at: Time.now
					)
				end
			end
	
			# Procesa solo el nodo actual en el progreso del usuario.
			process_current_node(campaign, user, user_progress) if user_progress
		end
  
    def all_conditions_met?(user, campaign)
			campaign.conditions.all? do |condition|
				# Para 'login_event', encuentra específicamente la última actividad de login.
				if condition.event_type == 'last_login'
					last_login_activity = user.user_activities.where(event_type: 'last_login').order(:logged_at).last
					last_login_activity.present? && activity_meets_condition?(last_login_activity, condition)
				else
					# Para otros tipos de condiciones, evalúa cualquier actividad relevante.
					user.user_activities.any? { |activity| activity_meets_condition?(activity, condition) }
				end
			end
		end
  
    def activity_meets_condition?(activity, condition)
			case condition.event_type
			when 'last_login'
				# Confirmamos que la actividad es de tipo login antes de verificar los días.
				return false unless activity.event_type == 'last_login'
				
				# Calculamos la diferencia en días entre la última actividad y ahora.
				last_login_time = activity.logged_at
				days_since_last_login = (Time.zone.now - last_login_time).to_i / 1.day
				
				# Verificamos si han pasado más días desde el último login que el valor en la condición.
				days_since_last_login > condition.criteria_value.to_i
			when 'account_creation'
				# Para la creación de la cuenta, no necesitamos comparar tipos de evento; evaluamos la antigüedad de la cuenta.
				return false unless activity.event_type == 'account_creation'
				
				creation_time = activity.data['created_at'].to_date
				days_since_creation = (Date.today - creation_time).to_i
				
				days_since_creation >= condition.criteria_value.to_i
			when 'page_visit'
				# En este caso, la actividad debe corresponder a una visita a página específica.
				return false unless activity.event_type == 'page_visit'
				
				activity.data['path'] == condition.criteria_value
			else
				# Si no reconocemos el tipo de evento de la condición, devolvemos false.
				false
			end
		end
      
  
    def process_current_node(campaign, user, user_progress)
			current_node = user_progress.node
	
			return if user_progress.completed
	
			case current_node.action_type
			when 'ActionWait'
				handle_wait_action(current_node, user, user_progress)
			when 'ActionEmail'
				handle_email_action(current_node, user, user_progress)
			end
		end
	
		def handle_wait_action(node, user, user_progress)
			wait_duration = node.action.duration.minutes
			time_elapsed = Time.now - user_progress.last_updated_at
	
			if time_elapsed >= wait_duration
				next_node = get_next_node(node)
				user_progress.update(node: next_node, last_updated_at: Time.now) if next_node
				user_progress.update(completed: node.next_node_id.nil?) unless next_node
			end
		end
	
		def handle_email_action(node, user, user_progress)
			email_action = ActionEmail.find_by(id: node.action_id)
			if email_action
				puts "Email Subject: #{email_action.subject}"
				puts "Email Body: #{email_action.body}"
				next_node = get_next_node(node)
				user_progress.update(node: next_node, last_updated_at: Time.now) if next_node
				user_progress.update(completed: node.next_node_id.nil?) unless next_node
			else
				puts "No email action found for node #{node.id}."
			end
		end
	
		def get_next_node(current_node)
			Node.find_by(id: current_node.next_node_id)
		end
  end
   