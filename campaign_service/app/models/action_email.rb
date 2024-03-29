class ActionEmail < ApplicationRecord
    has_one :node, as: :action
end
