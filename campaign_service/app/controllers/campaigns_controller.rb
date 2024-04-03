class CampaignsController < ApplicationController
  
  before_action :set_campaign, only: [:show, :update, :destroy]

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

  def destroy
    ActiveRecord::Base.transaction do
      @campaign.nodes.each do |node|
        Node.where(next_node_id: node.id).update_all(next_node_id: nil)
      end
  
      if @campaign.destroy
        head :no_content
      else
        render json: @campaign.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotDestroyed
    render json: { errors: 'Error al eliminar la campaña y sus nodos asociados.' }, status: :unprocessable_entity
  end

  private

  def set_campaign
    if action_name == 'show'
      @campaign = Campaign.includes(nodes: :action, conditions: {}, user_campaign_progress: {}).find(params[:id])
    else
      @campaign = Campaign.find(params[:id])
    end
  end

  def campaign_params
    params.require(:campaign).permit(:name, :description, :customer_group_id)
  end
end
