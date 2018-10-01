FactoryBot.define do
  factory :bill do
    amount { 200 }
    paid { true }
    user
    reservation

    transient do
      bill_items_count { 3 }
      invalid_bill_items { false }
    end
    after(:create) do |bill, evaluator|
      if evaluator.invalid_bill_items
        create_list(:bill_item, evaluator.bill_items_count, :invalid_bill_item, bill: bill)
      else
        create_list(:bill_item, evaluator.bill_items_count, bill: bill)
      end
    end

    trait :paid_false do
      paid { false }
    end

  end
end
