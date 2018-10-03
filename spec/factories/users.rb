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
      specialization { 'psychiatrist' }
    end

    trait :admin do
      admin { true }
      employee { true }
    end

    trait :random_specialization do
      sequence(:specialization) { |n| "specialization#{n}" }
    end

    factory :doctor_with_many_reservations do
      employee { true }
      specialization { 'psychiatrist' }

      transient do
        random_date { false }
        reservations_count { 3 }
        given_date { Time.now + 1.hour }
      end

      after(:create) do |user, evaluator|
        if evaluator.random_date
          create_list(:reservation, evaluator.reservations_count, :random_date, users: [user])
        else
          create_list(:reservation, evaluator.reservations_count,
                      date_time: evaluator.given_date, users: [user])
        end
      end
    end

    factory :user_with_many_bills do
      transient do
        bills_count { 3 }
        paid { true }
      end

      after(:create) do |user, evaluator|
        if evaluator.paid
          create_list(:bill, evaluator.bills_count, user: user)
        else
          create_list(:bill, evaluator.bills_count, :paid_false, user: user)
        end
      end
    end
    factory :user_doctor, traits: [:doctor]
  end
end
