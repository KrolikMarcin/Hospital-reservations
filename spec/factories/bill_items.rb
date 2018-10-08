FactoryBot.define do
  factory :bill_item do
    description { 'nurse helps' }
    price { 100 }

    trait :with_bill do
      association :bill
    end

    factory :bill_item_empty do
      description { '' }
      price { nil }
    end
  end
end
