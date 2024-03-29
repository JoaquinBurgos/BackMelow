class ActionWait < ApplicationRecord
    has_one :node, as: :action
end
