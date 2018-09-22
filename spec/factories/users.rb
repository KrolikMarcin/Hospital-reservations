FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@wp.pl" }
    sequence(:first_name) { |n| "Jonasz#{n}" }
    sequence(:last_name) { |n| "Koc#{n}" }
    pesel { Random.new.rand(10**8..999_999_999).to_i }
    password { 'asdasd' }
    employee { false }

    trait :doctor do
      employee { true }
      sequence(:specialization) { |n| "specialization#{n}" }
    end

    trait :admin do
      admin { true }
      employee { true }
    end

    factory :user_with_many_reservations do
      transient do
        reservations_count { 10 }
      end

      after(:create) do |user, evaluator|
        create_list(:reservation, evaluator.reservations_count,
                    users: [user])
      end
    end
    factory :user_doctor, traits: [:doctor]
  end
end
