FactoryBot.define do
  factory :campaign do
    name { "My Campaign" }
    description { "Campaign Description" }
    customer_group_id { 1 }
  end
end