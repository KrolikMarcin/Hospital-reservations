FactoryBot.define do
  factory :prescription do
    medicine { 'tramal' }
    recommendations { '3 times for day' }

    factory :invalid_prescription do
      medicine { nil }
      recommendations { nil }
    end
  end
end
