FactoryBot.define do
  factory :bill do
    amount { 200 }
    paid { true }
    user
    reservation

    transient do
      bill_items_count { 3 }
    end
    after(:create) do |bill, evaluator|
      create_list(:bill_item, evaluator.bill_items_count, bill: bill)
    end

    trait :paid_false do
      paid { false }
    end
  end
end
