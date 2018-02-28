FactoryBot.define do
  factory :preference do
    name          'notifications'
    value         false
    association   :owner, factory: :user
  end
end