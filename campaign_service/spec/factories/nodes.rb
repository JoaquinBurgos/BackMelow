FactoryBot.define do
  factory :node do
    campaign
    action { nil } # La asociación específica se establecerá en el test.
  end
end