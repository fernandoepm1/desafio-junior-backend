FactoryBot.define do
  factory :user do
    name { Faker::Superhero.name }
    email { Faker::Internet.email }
    password { 'secretsecret' }
    password_confirmation { 'secretsecret' }

    trait :invalid_email do
      email { nil }
    end

    trait :invalid_password do
      password { 'secret' }
    end

    trait :master do
      permission { :master }
    end

    factory :invalid_user, traits: %i[invalid_password]
    factory :admin,        traits: %i[master]
  end
end