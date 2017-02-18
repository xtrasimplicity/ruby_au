FactoryGirl.define do
  factory :profile do
    full_name { Faker::Name.name }
    preferred_name { full_name.to_s.split(' ').first }
    created_at { DateTime.now }
    mailing_list { Faker::Boolean }
    description { Faker::Lorem.sentence }
    twitter { "@#{full_name.to_s.gsub(' ', '_')}" }
    website { "http://#{full_name.to_s.gsub(' ','_')}.com" }
    is_public { Faker::Boolean }
    location { "#{Faker::Address.city}, #{Faker::Address.country}" }
  end
end
