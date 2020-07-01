FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'secretsecret' }
    password_confirmation { 'secretsecret' }

    trait :invalid_email do
      email { nil }
    end

    trait :master do
      permission { :master }
    end

    factory :admin, traits: %i[master]
  end
end
