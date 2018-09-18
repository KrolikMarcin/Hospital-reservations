FactoryBot.define do
  factory :reservation do
    date_time { Time.now }
    doctor_specialization { 'psychiatrist' }
  end
end
