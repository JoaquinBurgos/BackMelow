class CampaignMonitorWorker
    include Sidekiq::Worker
  
    def perform
			Rails.logger.info "CampaignMonitorWorker is executing..."
      Campaign.includes(:conditions).find_each do |campaign|
        User.find_each do |user|
          process_activities_for_campaign(user, campaign)
        end
      end
    end
  
    private
  
	def process_activities_for_campaign(user, campaign)
		return if campaign.conditions.empty?
	  
		user_progress = UserCampaignProgress.find_by(user: user, campaign: campaign)
	  
		if user_progress.nil?
		  if all_conditions_met?(user, campaign)
			Rails.logger.info "Creating progress for user #{user.id} and campaign #{campaign.id}."
			user_progress = UserCampaignProgress.create(
			  user: user, 
			  campaign: campaign, 
			  node: campaign.first_node, 
			  last_updated_at: Time.now
			)
		  end
		elsif !user_progress.completed
		  process_current_node(campaign, user, user_progress)
		end
	end
  
	def all_conditions_met?(user, campaign)
		Rails.logger.info "Checking conditions for user #{user.id} and campaign #{campaign.id}..."
		campaign.conditions.all? do |condition|
			if condition.event_type == 'last_login'
				last_login_activity = user.user_activities.where(event_type: 'last_login').max_by do |activity|
					Time.parse(activity['data']['logged_at'])
				end
				activity_meets_condition?(last_login_activity, condition) unless last_login_activity.nil?
			else
				user.user_activities.any? { |activity| activity_meets_condition?(activity, condition) }
			end
		end
	end
  
    def activity_meets_condition?(activity, condition)
			case condition.event_type
			when 'last_login'
				return false unless activity.event_type == 'last_login'
				
				last_login_time = activity['data']['logged_at']
				days_since_last_login = (Time.zone.now - Time.parse(last_login_time)).to_i / 1.day
				puts "Days since last login: #{days_since_last_login}"
				days_since_last_login > condition.criteria_value.to_i
			when 'account_creation'
				return false unless activity.event_type == 'account_creation'
				
				creation_time = activity.data['created_at'].to_date
				days_since_creation = (Date.today - creation_time).to_i
				
				days_since_creation >= condition.criteria_value.to_i
			when 'page_visit'
				return false unless activity.event_type == 'page_visit'
				
				activity.data['path'] == condition.criteria_value
			else
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
			puts 'The User is waiting.'
			if time_elapsed >= wait_duration
				puts 'The User has been waiting for too long. Moving to the next node.'
				next_node = get_next_node(node)
				user_progress.update(node: next_node, last_updated_at: Time.now) if next_node
				user_progress.update(completed: node.next_node_id.nil?) unless next_node
			end
		end
	
		def handle_email_action(node, user, user_progress)
			email_action = ActionEmail.find_by(id: node.action_id)
			if email_action
				puts "Email Subject: #{email_action.subject} to #{user.email}"
				puts "Email Body: #{email_action.body}"
				UserMailer.send_campaign_email(user, email_action).deliver_now
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
   