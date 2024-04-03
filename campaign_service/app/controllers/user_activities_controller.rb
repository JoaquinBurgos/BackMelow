class UserActivitiesController < ApplicationController
    before_action :set_user, only: [:create]
  
    def create
      user_activity = @user.user_activities.new(user_activity_params)
  
      if valid_user_activity_data?(user_activity) && user_activity.save
        render json: user_activity, status: :created
      else
        render json: { error: 'Invalid data', expected_formats: expected_formats }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_activity][:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end
  
    def user_activity_params
      params.require(:user_activity).permit(:event_type, :user_id, data: {})
    end
  
    def valid_user_activity_data?(user_activity)
      case user_activity.event_type
      when 'last_login'
        date_string = user_activity.data['logged_at']
        date_string.present? && valid_date_format?(date_string)
			when 'account_creation'
				date_string = user_activity.data['created_at']
				date_string.present? && valid_date_format?(date_string)
      when 'page_visit'
        user_activity.data['path'].present?
      else
        false
      end
    end
  
    def valid_date_format?(date_string)
      date_iso8601?(date_string) || date_only?(date_string)
    end
  
    def date_iso8601?(date_string)
      Time.iso8601(date_string)
      true
    rescue ArgumentError
      false
    end
  
    def date_only?(date_string)
      Date.parse(date_string)
      true
    rescue ArgumentError
      false
    end
  
    def expected_formats
      {
        'event_type: last_login' => { data: { logged_at: 'ISO8601 format date string or YYYY-MM-DD' } },
        'event_type: account_creation' => { data: { created_at: 'ISO8601 format date string or YYYY-MM-DD' } },
        'event_type: page_visit' => { data: { path: 'URL path string' } }
      }
    end
  end
  