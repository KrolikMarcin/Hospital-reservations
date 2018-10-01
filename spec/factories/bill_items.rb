FactoryBot.define do
  factory :bill_item do
    description { 'nurse helps'}
    price { 100 }
    bill

    trait :invalid_bill_item do
      description { '' }
      price { nil }
    end
  end
end
