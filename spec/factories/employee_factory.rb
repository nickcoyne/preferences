FactoryGirl.define do
  factory :employee do
    name 'John Smith'

    trait :manager do
    end
  end

  factory :manager, parent: :employee, class: 'Manager' do
  end
end