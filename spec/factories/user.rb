# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  first_name     :string           not null
#  last_name      :string           not null
#  address_line_1 :string           not null
#  dob            :date             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address_line_1 { Faker::Address.street_address }
    dob { Faker::Date.birthday(18, 99) }
  end
end
