FactoryBot.define do
  factory :user_activity do
    user
    event_type { "login" }
    data { { ip: "127.0.0.1" } }
  end
end
