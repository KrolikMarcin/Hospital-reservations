FactoryBot.define do
  factory :reservation do
    sequence(:date_time) { |n| Time.now + n.day }
    doctor_specialization { 'psychiatrist' }

    factory :reservation_with_patient do
      after(:create) do |reservation|
        create_list(:user, 1, reservations: [reservation])
      end
    end
    factory :reservation_with_patient_and_doctor do
      after(:create) do |reservation|
        create_list(:user, 1, reservations: [reservation])
        create_list(:user, 1, :employee, specialization: 'psychiatrist',
                                         reservations: [reservation])
      end
    end
    factory :invalid_reservation do
      doctor_specialization { nil }
    end
    factory :reservation_with_prescriptions do
      transient do
        prescriptions_count { 3 }
      end
      after(:create) do |reservation, evaluator|
        build_list(:prescription, evaluator.prescriptions_count, reservation: reservation)
      end
    end
  end
end
