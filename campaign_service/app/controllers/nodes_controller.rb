class NodesController < ApplicationController
    before_action :set_campaign
		before_action :set_node, only: [:show, :update, :destroy]

		def show
			render json: @node, include: :action
		end

		def create
			ActiveRecord::Base.transaction do
				action = create_action(params[:node][:action_type], node_params[:action])
		
				if action.persisted?
					@node = @campaign.nodes.build(node_params.except(:action, :parent_node_id).merge(action: action, action_type: params[:node][:action_type]))
		
					if @node.save
						@campaign.update(first_node_id: @node.id) unless @campaign.first_node_id

						set_parent_node(@node, params[:node][:parent_node_id]) if params[:node][:parent_node_id].present?
						
						if params[:node][:parent_node_id].blank? && @campaign.first_node_id != @node.id
							insert_node_at_beginning(@node)
						end
						render json: @node, status: :created
					else
						render json: { errors: @node.errors.full_messages }, status: :unprocessable_entity
					end
				else
					render json: { errors: action.errors.full_messages }, status: :unprocessable_entity
				end
			end
		rescue StandardError => e
			render json: { error: e.message }, status: :unprocessable_entity
		end
  
		def destroy
			ActiveRecord::Base.transaction do
				@node = @campaign.nodes.find(params[:id])
				
				if @campaign.first_node_id == @node.id
					new_first_node_id = @node.next_node_id.present? ? @node.next_node_id : nil
					@campaign.update(first_node_id: new_first_node_id)
				end
				
				previous_node = @campaign.nodes.find_by(next_node_id: @node.id)
				
				if previous_node
					previous_node.update!(next_node_id: @node.next_node_id)
				end
				
				@node.destroy
		
				render json: { message: "Node successfully deleted" }, status: :ok
			rescue ActiveRecord::RecordNotFound
				render json: { error: "Node not found" }, status: :not_found
			rescue => e
				render json: { error: e.message }, status: :unprocessable_entity
			end
		end

		def update
			ActiveRecord::Base.transaction do
				new_action = create_action(params[:node][:action_type], node_params[:action])
				
				if new_action.persisted?
					@node.action.destroy if @node.action
		
					if @node.update(action: new_action)
						render json: @node, status: :ok
					else
						puts "@node.errors.full_messages"
						render json: { errors: @node.errors.full_messages }, status: :unprocessable_entity
					end
				else
					puts "new_action.errors.full_messages"
					render json: { errors: new_action.errors.full_messages }, status: :unprocessable_entity
				end
			end
		rescue ActiveRecord::RecordNotFound
			render json: { error: "Node not found" }, status: :not_found
		rescue => e
			render json: { error: e.message }, status: :unprocessable_entity
		end

    private
  
		def set_campaign
			campaign_id = params[:campaign_id].to_i
			@campaign = Campaign.find(params[:campaign_id])
		end
  
		def node_params
			params.require(:node).permit(:parent_node_id, :action_type, action: [:subject, :body, :duration])
		end
  
    def create_action(action_type, action_params)
      case action_type
      when 'ActionEmail'
        ActionEmail.create(action_params.slice(:subject, :body))
      when 'ActionWait'
        ActionWait.create(action_params.slice(:duration))
      else
        nil
      end
    end

		def set_node
			@node = @campaign.nodes.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			render json: { error: "Node not found" }, status: :not_found
		end

		def insert_node_at_beginning(new_node)
			current_first_node = @campaign.nodes.find_by(id: @campaign.first_node_id)
			@campaign.update(first_node_id: new_node.id)
			new_node.update(next_node_id: current_first_node&.id)
		end
		
    def set_parent_node(node, parent_node_id)
      parent_node = Node.find_by(id: parent_node_id, campaign_id: @campaign.id)
			if parent_node.next_node_id.present?
				node.update!(next_node_id: parent_node.next_node_id)
			end
      parent_node.update!(next_node_id: node.id) if parent_node
    end
end
  