FactoryBot.define do
  factory :address do
    street { 'Lesna' }
    house_number { '10' }
    apartment_number { '15' }
    city { 'Warsow ' }
    postal_code { '30-155' }
    user

    factory :invalid_address do
      street { nil }
      city { nil }
    end
  end
end
