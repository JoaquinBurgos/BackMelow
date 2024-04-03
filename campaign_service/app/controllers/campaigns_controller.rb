class CampaignsController < ApplicationController
  
  before_action :set_campaign, only: [:show, :update]

  def index
    @campaigns = Campaign.all
    render json: @campaigns
  end

  def show
    render json: @campaign
  end

  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      render json: @campaign, status: :created
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  def update
    if @campaign.update(campaign_params)
      render json: @campaign
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  private

  def set_campaign
    if action_name == 'show'
      @campaign = Campaign.includes(nodes: :action, conditions: {}).find(params[:id])
    else
      @campaign = Campaign.find(params[:id])
    end
  end

  def campaign_params
    params.require(:campaign).permit(:name, :description, :customer_group_id)
  end
end
