FactoryBot.define do
  factory :reservation do
    date_time { Time.now + 1.hour }
    doctor_specialization { 'psychiatrist' }

    factory :reservation_with_patient do
      after(:create) do |reservation|
        create_list(:user, 1, reservations: [reservation])
      end
    end

    factory :reservation_with_patient_and_doctor do
      after(:create) do |reservation|
        create(:user, reservations: [reservation])
        create(:user_doctor, reservations: [reservation])
      end
    end

    factory :invalid_reservation do
      doctor_specialization { nil }
      date_time { Time.new(2013, 1, 1) }
    end

    trait :random_date do
      sequence(:date_time) { |n| Time.now + n.day }
    end
  end
end
