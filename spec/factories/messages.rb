FactoryBot.define do
  factory :message do
    title { Faker::Name.name }
    content { 'Lorem ipsum' }
    from factory: :user
    to factory: :user

    trait :no_from do
      from nil
    end

    trait :no_to do
      to nil
    end

    trait :read do
      status { :read }
    end

    trait :archived do
      status { :archived }
    end

    trait :no_content do
      content { nil }
    end

    factory :invalid_message,  traits: %i[no_content]
    factory :read_message,     traits: %i[read]
    factory :archived_message, traits: %i[archived]
  end
end
