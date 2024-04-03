class ConditionsController < ApplicationController
    before_action :set_campaign
    before_action :set_condition, only: [:update, :destroy]
  
    # POST /campaigns/:campaign_id/conditions
    def create
      @condition = @campaign.conditions.new(condition_params)
  
      if @condition.save
        render json: @condition, status: :created
      else
        render json: @condition.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /campaigns/:campaign_id/conditions/:id
    def update
      if @condition.update(condition_params)
        render json: @condition
      else
        render json: @condition.errors, status: :unprocessable_entity
      end
    end
    
    def destroy
        @condition.destroy
        head :no_content
    end
    
    private
  
    def set_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end
  
    def set_condition
      @condition = @campaign.conditions.find(params[:id])
    end
  
    def condition_params
      # Aquí asumimos que ya no necesitas pasar campaign_id en los parámetros
      params.require(:condition).permit(:event_type, :criteria_key, :criteria_value)
    end
  end
  